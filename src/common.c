#include "shim.h"

shim_val_t* create_error(shim_ctx_t *ctx, char *msg, CK_RV return_code) {
    shim_val_t *error_obj = shim_error_new(ctx, msg);
    shim_val_t *error_code = shim_number_new(ctx, return_code);
    shim_obj_set_prop_name(ctx, error_obj, "code", error_code);
    shim_value_release(error_code);
    return error_obj;
}