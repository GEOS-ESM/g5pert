esma_set_this()

# Create fvgcm.h
# NOTE:  This is woefully out of date and hardwires a resolution.
# I am translating from GNUmake under duress.  TLC

set (FVGCMRES b72)
set (FVGCMTRC 1)

add_custom_command (OUTPUT fvgcm.h
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/fvsetdim -t ${FVGCMTRC} ${FVGCMRES}
  COMMENT where or where 
  )

add_custom_target (fvgcm_inc DEPENDS fvgcm.h)

esma_add_library (${this} 
   SRCS ecbuild_kludge.F90
   )
add_dependencies (${this} fvgcm_inc)
target_include_directories (${this} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)

if (EXTENDED_SOURCE)
  target_compile_options (${this} PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:${EXTENDED_SOURCE}>)
endif()


target_compile_definitions (${this} PRIVATE REAL8 LSMH_off VERSION=\"fvgcm\")
target_compile_definitions (${this} PRIVATE SPMD  GFIO CHECKPOINTING LINUX)
string(REPLACE " " ";" tmp ${FREAL8})
foreach(flag ${tmp})
  target_compile_options (${this} PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:${flag}>)
endforeach()

esma_add_subdirectories (
  csm_share atmlnd_share pilgrim ecmfft phys lsm misc drvs fvcore fvtlm fvadm fvptrace
)

target_link_libraries (${this} PUBLIC GMAO_hermes GMAO_mpeu)
