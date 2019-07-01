esma_set_this ()

esma_add_library (${this}
  SRCS m_fvpsas.F90
  DEPENDENCIES fvgcm GMAO_transf
  )

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
