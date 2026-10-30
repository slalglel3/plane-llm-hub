package com.plane.llmhub.mapper;

import com.plane.llmhub.model.ModelContent;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ContentMapper {
    List<ModelContent> selectByModelId(@Param("modelId") Long modelId);
    ModelContent selectByModelIdAndType(@Param("modelId") Long modelId, @Param("subMenuType") String subMenuType);
    int insert(ModelContent content);
    int update(ModelContent content);
}
