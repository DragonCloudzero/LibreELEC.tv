
#include <stddef.h>
#include "mali_gbm.h"

void *
gbm_bo_map(struct gbm_bo *bo,
           uint32_t x, uint32_t y, uint32_t width, uint32_t height,
           uint32_t flags, uint32_t *stride, void **map_data)
{
    if (bo->map) {
        *map_data = (char *)bo->map + (bo->pitch * y) + (x * 4);
        *stride = bo->pitch;
        return *map_data;
    }

    return NULL;
}

void
gbm_bo_unmap(struct gbm_bo *bo, void *map_data)
{
    return;
}
