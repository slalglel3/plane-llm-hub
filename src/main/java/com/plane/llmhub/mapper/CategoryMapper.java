package com.plane.llmhub.mapper;

import com.plane.llmhub.model.Category;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CategoryMapper {
    List<Category> selectAll();
    List<Category> selectByModule(@Param("moduleType") String moduleType);
    Category selectBySlug(@Param("slug") String slug);
    Category selectById(@Param("id") Long id);
    int insert(Category category);
}
