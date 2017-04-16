defmodule MixAndComplete do
  use NVim.Plugin
  require Logger

  defp mix_load("/"<>path) do
    mix_dir = path |> Path.split |> Enum.reduce([""],&["#{hd(&2)}/#{&1}"|&2])
                   |> Enum.reverse |> Enum.find(&File.exists?("#{&1}/mix.exs"))
    if mix_dir do
      Mix.start #ensure mix is started
      old_proj=Mix.Project.pop
      Code.load_file(mix_dir<>"/mix.exs")
      if old_proj do
        Logger.info("Replace project #{old_proj.config[:app]} by #{Mix.Project.config[:app]}")
      else
        Logger.info("Load project #{Mix.Project.config[:app]}")
      end
      if File.exists?(mix_dir<>"/config/config.exs"), do: 
        Mix.Task.run("loadconfig", [mix_dir<>"/config/config.exs"])
      :file.set_cwd('#{mix_dir}') # if your application read files
      for p<-Path.wildcard("#{mix_dir}/_build/#{Mix.env}/lib/*/ebin"), do: :code.add_pathz('#{p}')
    else
      Logger.info("Cannot find any mix project in parent dirs")
    end
  end

  defp format_bindings(bindings) do
    bindings |> Enum.map(fn {k,v}->"#{k} = #{inspect(v,pretty: true)}" end) |> Enum.join("\n")
  end

  defp add_specs(specs,{f,a},doc) do
    case format_specs(Enum.filter(specs, fn {{f0,a0},_}-> f0 == f and a0 == a end)) do
      ""->doc
      str->"#{str}\n\n#{doc}"
    end
  end
  defp add_specs(specs,doc) do
    case format_specs(specs) do
      ""->doc
      str->"#{doc}\n\n## Specs: \n\n#{str}"
    end
  end
  defp format_specs(specs) do
    Enum.flat_map(specs, fn {{f,_},specs}->Enum.map(specs,& {f,&1}) end)
    |> Enum.map(fn {f,spec}-> "    "<>Macro.to_string(Kernel.Typespec.spec_to_ast(f,spec)) end)
    |> Enum.join("\n")
  end

  def init(_) do
    mix_load(System.cwd)
    {:ok,%{current_bindings: []}}
  end

  defcommand mix_start(app,_), async: true do
    Application.ensure_all_started(app && :"#{app}" || Mix.Project.config[:app])
  end

  defcommand mix_stop(app,_), async: true do
    Application.stop(app && :"#{app}" || Mix.Project.config[:app])
  end

  defcommand mix_load(file_dir,state), eval: "expand('%:p:h')", async: true do
    mix_load(file_dir)
  end

  defcommand elixir_exec(bang,[starts,ends],state), bang: true, range: :default_all do
    {:ok,buffer} = NVim.vim_get_current_buffer
    {:ok,text} = NVim.buffer_get_line_slice(buffer,starts-1,ends-1,true,true)
    tmp_dir = System.tmp_dir || "."
    current_bindings = if bang == 0, do: state.current_bindings, else: []
    bindings = try do
      {res,bindings} = Code.eval_string(Enum.join(text,"\n"),current_bindings)
      File.write!("#{tmp_dir}/preview.ex","#{inspect(res,pretty: true)}\n\n#{format_bindings bindings}")
      bindings
    catch
      kind,err-> 
        format_err = Exception.format(kind,err,System.stacktrace)
        File.write! "#{tmp_dir}/preview.ex","#{format_err}\n\n#{format_bindings current_bindings}"
        current_bindings
    end
    NVim.vim_command("pedit! #{tmp_dir}/preview.ex")
    {:ok,nil,%{state| current_bindings: bindings}}
  end

  deffunc elixir_complete("1",_,cursor,line,state), eval: "col('.')", eval: "getline('.')" do
    cursor = cursor - 1 # because we are in insert mode
    [tomatch] = Regex.run(~r"[\w\.:]*$",String.slice(line,0..cursor-1))
    cursor - String.length(tomatch)
  end
  deffunc elixir_complete(_,base,_,_,state), eval: "col('.')", eval: "getline('.')" do
    case (base |> to_char_list |> Enum.reverse |> IEx.Autocomplete.expand) do
      {:no,_,_}-> [base] # no expand
      {:yes,comp,[]}->["#{base}#{comp}"] #simple expand, no choices
      {:yes,_,alts}-> # multiple choices
        Enum.map(alts,fn comp->
          {base,comp} = {String.replace(base,~r"[^.]*$",""), to_string(comp)}
          case Regex.run(~r"^(.*)/([0-9]+)$",comp) do # first see if these choices are module or function
            [_,function,arity]-> # it is a function completion
              replace = base<>function
              module = if String.last(base) == ".", do: Module.concat([String.slice(base,0..-2)]), else: Kernel
              f = :"#{function}"; a = String.to_integer(arity)
              specs = Enum.concat(Kernel.Typespec.beam_specs(module) || [], Kernel.Typespec.beam_callbacks(module) || [])

              if (docs=Code.get_docs(module,:docs)) && (doc=List.keyfind(docs,{f,a},0)) && (docmd=elem(doc,4)) do
                 %{"word"=>replace,"kind"=> if(elem(doc,2)==:def, do: "f", else: "m"), "abbr"=>comp,"info"=>add_specs(specs,{f,a},docmd)}
              else
                %{"word"=>replace,"abbr"=>comp}
              end
            nil-> # it is a module completion
              module_name = base<>comp
              module = Module.concat([module_name])
              specs = Enum.concat(Kernel.Typespec.beam_specs(module) || [], Kernel.Typespec.beam_callbacks(module) || [])
              case Code.get_docs(module,:moduledoc) do
                {_,moduledoc} -> %{"word"=>module_name,"info"=>add_specs(specs,moduledoc)}
                _ -> %{"word"=>module_name, "info"=>add_specs(specs,"")}
              end
          end
        end)
    end
  end
end
