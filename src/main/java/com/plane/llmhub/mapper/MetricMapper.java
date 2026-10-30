package com.plane.llmhub.mapper;

import com.plane.llmhub.model.ModelMetric;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MetricMapper {
    List<ModelMetric> selectByModelId(@Param("modelId") Long modelId);
    List<ModelMetric> selectAllLeaderboard();
    int insert(ModelMetric metric);
}
