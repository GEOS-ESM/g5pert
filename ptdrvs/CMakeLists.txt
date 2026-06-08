cmake_minimum_required (VERSION 3.24)  # LINK_GROUP:RESCAN requires 3.24+

esma_set_this ()

esma_add_library (${this}
  SRCS m_fvpsas.F90
  DEPENDENCIES fvgcm GMAO_transf
  )

ecbuild_add_executable(TARGET fvmodel.x SOURCES fvmodel.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET fvpert.x SOURCES fvpert.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET fvsens.x SOURCES fvsens.F90 LIBS GMAO_mpeu fvgcm svec parpack)
#fvsvec has circular dependencies between svec, arpack, parpack, planso, and lanso.
#Use LINK_GROUP:RESCAN (CMake 3.24+) to generate --start-group/--end-group so the
#linker repeatedly scans those archives until all references are resolved.
ecbuild_add_executable(TARGET fvsvec.x SOURCES fvsvec.F90)
target_link_libraries(fvsvec.x PRIVATE
   "$<LINK_GROUP:RESCAN,svec,arpack,parpack,planso,lanso>"
   fvgcm GMAO_hermes GMAO_gfio_r8 util putil GMAO_mpeu)
ecbuild_add_executable(TARGET jactest.x SOURCES jactest.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET qpert.x SOURCES qpert.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET qsens.x SOURCES qsens.F90 LIBS GMAO_mpeu fvgcm svec parpack)

target_compile_definitions (${this} PRIVATE REAL8 LSMH_off VERSION=\"fvgcm\")
target_compile_definitions (${this} PRIVATE SPMD  GFIO CHECKPOINTING LINUX)

foreach (target ${this} fvmodel.x fvpert.x fvsens.x fvsvec.x jactest.x qpert.x qsens.x)
   string(REPLACE " " ";" tmp ${FREAL8})
   foreach(flag ${tmp})
      target_compile_options (${target} PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:${flag}>)
   endforeach()
endforeach ()

foreach (rc fvsvec jactest pseudo tracer)
  install (
    FILES ${rc}.rc.sample
    DESTINATION etc
    RENAME ${rc}.rc
   )
endforeach ()

file (GLOB tmpl_files *.tmpl)

install (
   FILES ${tmpl_files} fvgcm.ccmflags.namelist
   DESTINATION etc
   )
