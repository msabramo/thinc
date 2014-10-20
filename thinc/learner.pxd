from cymem.cymem cimport Pool

from preshed.maps cimport PreshMap
from preshed.maps cimport PreshMapArray
from preshed.maps cimport MapStruct
from preshed.maps cimport Cell

from .cache cimport ScoresCache

from .weights cimport WeightLine
from .weights cimport TrainFeat
from .typedefs cimport *


DEF LINE_SIZE = 8

cdef class LinearModel:
    cdef time_t time
    cdef readonly class_t nr_class
    cdef size_t n_corr
    cdef size_t total
    cdef Pool mem
    cdef PreshMapArray weights
    cdef ScoresCache cache
    cdef weight_t* scores
    cdef WeightLine** _weight_lines

    cdef class_t score(self, weight_t* scores, feat_t* features, weight_t* values,
            int n_feats) except *
    cdef int update(self, class_t clas, feat_t* feats, weight_t* values, int n) except -1