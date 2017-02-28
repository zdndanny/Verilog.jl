##codegen.jl
# functions relating to verilog code generation and verilation.

doc"""
  `generate_verilog_file(path, mod, (params...))`

  pass this function a path, (verilog module) name and the parameters, and it puts that
  module and its dependencies into the file.
"""
#TODO: Pass parameters for dependencies which are to be omitted.
function generate_verilog_file(path::String, mod::Function, p::Tuple)
  #test to see if the path exists.
  isdir(path) || mkdir(path)
  #first call the function and make it.
  modulestring = mod(p...)
  modulename = ""

  #next, retrieve the proper name for the file.
  for key in keys(__global_definition_cache)
    if key[1] == Symbol(mod)
      if [p...] == [pair.second for pair in key[2:end]]
        println(__global_definition_cache[key].module_name)
        modulename = __global_definition_cache[key].module_name
        break
      end
    end
  end

  #next, create a file for the header.
  vfile_fio = open(string(path, "/", modulename, ".v"), "w")
  try
    #write the contents
    println(vfile_fio, modulestring)
  finally
    #close the directory
    close(vfile_fio)
  end
end

export generate_verilog_file

doc"""
  `verilate(path_to_library::String, mods::Array)`
  uses verilator to create a .so file corresponding to the library.
  Each of the functions in the mods array will be the top-level element
  in a freestanding .v file.  They may refer to each other.
  the "mods" are a tuple of the function and the parameter.
"""
function verilate(path_for_library::String, modules::Array)
  #create into tdir the .v files.
  for mod in modules
    generate_verilog_file(path, )

  end
  #=
  #check to see if the path_to_c_library is actually a dir.
  isdir(path_to_c_library) || return nothing

  #create the temp directory
  mktempdir((tdir)->begin
    #next, copy the contents of path_to_c_library into the temp directory
    cp(path_to_c_library, tdir; remove_destination=true)

    #then, generate the c files for all of the desired lattices.
    for lattice_label in pfloat_labels
    PType = import_lattice(lattice_label)
    generate_lattice_files(string(tdir,"/src"), "../include", lattice_label, PType)
    end

    cgen.compile(tdir)
    cgen.link(tdir)

    respath = joinpath(destination_dir,"libpfloat.so")
    #now move the thing out of the temporary directory
    cp(joinpath(tdir, "libpfloat.so"), respath, remove_destination=true)

    #return the path for the resulting library
    respath
  =#
end
