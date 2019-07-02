esma_set_this ()

esma_add_library (${this}
  SRCS m_fvpsas.F90
  DEPENDENCIES fvgcm GMAO_transf
  )

ecbuild_add_executable(TARGET fvmodel.x SOURCES fvmodel.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET fvpert.x SOURCES fvpert.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET fvsens.x SOURCES fvsens.F90 LIBS GMAO_mpeu fvgcm svec parpack)
#fvsvec still needs work cicurlar dependecny between arpch and g5pert
#ecbuild_add_executable(TARGET fvsvec.x SOURCES fvsvec.F90 LIBS GMAO_mpeu fvgcm svec arpack parpack lanso planso svec)
ecbuild_add_executable(TARGET jactest.x SOURCES jactest.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET qpert.x SOURCES qpert.F90 LIBS GMAO_mpeu fvgcm svec parpack)
ecbuild_add_executable(TARGET qsens.x SOURCES qsens.F90 LIBS GMAO_mpeu fvgcm svec parpack)

target_compile_definitions (${this} PRIVATE REAL8 LSMH_off VERSION=\"fvgcm\")
target_compile_definitions (${this} PRIVATE SPMD  GFIO CHECKPOINTING LINUX)
string(REPLACE " " ";" tmp ${FREAL8})
foreach(flag ${tmp})
  target_compile_options (${this} PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:${flag}>)
endforeach()

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
