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

install (
   FILES fvsvec.rc.sample
   DESTINATION etc
   RENAME fvsvec.rc
   )

install (
   FILES jactest.rc.sample
   DESTINATION etc
   RENAME jactest.rc
   )

install (
   FILES pseudo.rc.sample
   DESTINATION etc
   RENAME pseudo.rc
   )

install (
   FILES tracer.rc.sample
   DESTINATION etc
   RENAME tracer.rc
   )

file (GLOB tmpl_files *.tmpl)

install (
   FILES ${tmpl_files} fvgcm.ccmflags.namelist
   DESTINATION etc
   )
