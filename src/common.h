#ifndef _COMMON_H_
#define _COMMON_H_

#include "shim.h"
#include "pkcs11.h"

// keeps track of our list of PKCS#11 functions
extern CK_FUNCTION_LIST_PTR pFuncList;


shim_val_t* create_error(shim_ctx_t *ctx, char *msg, CK_RV return_code);


#endif /* _COMMON_H_ */
