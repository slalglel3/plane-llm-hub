package com.plane.llmhub.mapper;

import com.plane.llmhub.model.LlmModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ModelMapper {
    List<LlmModel> selectAll();
    List<LlmModel> selectByCategoryId(@Param("categoryId") Long categoryId);
    List<LlmModel> selectByCategorySlug(@Param("categorySlug") String categorySlug);
    LlmModel selectByModelKey(@Param("modelKey") String modelKey);
    LlmModel selectById(@Param("id") Long id);
    List<LlmModel> searchModels(@Param("keyword") String keyword);
    int insert(LlmModel model);
}
