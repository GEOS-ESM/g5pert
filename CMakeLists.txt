if (CMAKE_Fortran_COMPILER_ID MATCHES Intel)
   set (CMAKE_Fortran_FLAGS_RELEASE "${FOPT3} ${OPTREPORT0} ${FTZ} ${ALIGN_ALL} ${NO_ALIAS} ${TRACEBACK} ${REALLOC_LHS} -w -cm ${FOPT3} -cpp -mp ${BIG_ENDIAN} ${ALIGNCOM}")
endif ()

add_subdirectory (fvgcm)
add_subdirectory (svec)
add_subdirectory (ptdrvs)
