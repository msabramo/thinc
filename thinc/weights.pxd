from .typedefs cimport weight_t, feat_t, class_t, count_t, time_t

from libc.stdint cimport uint64_t
from libc.stdint cimport uint32_t
from libc.stdint cimport uint16_t

from cymem.cymem cimport Pool

from preshed.maps cimport PreshMap
from preshed.maps cimport PreshMapArray
from preshed.maps cimport MapStruct
from preshed.maps cimport Cell

from .features cimport Feature


# Number of weights in a line. Should be aligned to cache lines.
DEF LINE_SIZE = 8

ctypedef weight_t[LINE_SIZE] weight_line_t


# A set of weights, to be read in. Start indicates the class that w[0] refers
# to. Subsequent weights go from there.
cdef struct WeightLine:
    weight_line_t line
    int start


cdef struct MetaData:
    weight_t total
    time_t time
    #weight_t rms_grad
    #weight_t rms_upd
    

cdef struct MDLine:
    MetaData[LINE_SIZE] line


cdef struct TrainFeat:
    WeightLine* weights
    MDLine* meta
    uint32_t length
    uint32_t _resize_at


cdef int average_weight(TrainFeat* feat, const class_t nr_class, const time_t time) except -1
cdef TrainFeat* new_train_feat(const class_t nr_class) except NULL
cdef int perceptron_update_feature(TrainFeat* feat, class_t clas, weight_t upd,
                                   time_t time, class_t nr_classes) except -1
cdef int gather_weights(MapStruct* maps, const class_t nr_class,
                        WeightLine* w_lines, const Feature* feats, const int n_feats) except -1
cdef int set_scores(weight_t* scores, const WeightLine* weight_lines,
                    const class_t nr_rows, const class_t nr_class) except -1
 

cdef class_t get_nr_rows(const class_t n) nogil

cdef void free_feature(TrainFeat* feat) nogil
