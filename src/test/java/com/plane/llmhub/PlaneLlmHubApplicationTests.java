package com.plane.llmhub;

import com.plane.llmhub.model.Category;
import com.plane.llmhub.model.LlmModel;
import com.plane.llmhub.service.LlmService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class PlaneLlmHubApplicationTests {

    @Autowired
    private LlmService llmService;

    @Test
    @DisplayName("Spring Context and H2 Schema initialization test")
    void contextLoads() {
        assertNotNull(llmService);
    }

    @Test
    @DisplayName("MyBatis CategoryMapper XML query test")
    void testCategoryMapper() {
        List<Category> categories = llmService.getAllCategories();
        assertNotNull(categories);
        assertTrue(categories.size() >= 5, "Expected at least 5 categories loaded from data.sql");
        
        Category openai = categories.stream().filter(c -> "openai".equals(c.getSlug())).findFirst().orElse(null);
        assertNotNull(openai);
        assertEquals("OpenAI", openai.getName());
        assertNotNull(openai.getModels());
        assertFalse(openai.getModels().isEmpty());
    }

    @Test
    @DisplayName("MyBatis ModelMapper and ContentMapper XML query test")
    void testModelDetails() {
        LlmModel claude = llmService.getModelDetailsByKey("claude-3-7-sonnet");
        assertNotNull(claude);
        assertEquals("Claude 3.7 Sonnet", claude.getName());
        assertEquals("Anthropic", claude.getProvider());
        
        assertNotNull(claude.getContents(), "Contents should not be null");
        assertFalse(claude.getContents().isEmpty(), "Claude 3.7 Sonnet should have sub-menu contents");
        
        // Verify 5 sub-menu types
        boolean hasOverview = claude.getContents().stream().anyMatch(c -> "OVERVIEW".equals(c.getSubMenuType()));
        boolean hasUsage = claude.getContents().stream().anyMatch(c -> "USAGE".equals(c.getSubMenuType()));
        boolean hasProsCons = claude.getContents().stream().anyMatch(c -> "PROS_CONS".equals(c.getSubMenuType()));
        boolean hasBenchmarks = claude.getContents().stream().anyMatch(c -> "BENCHMARKS".equals(c.getSubMenuType()));
        boolean hasLinks = claude.getContents().stream().anyMatch(c -> "LINKS".equals(c.getSubMenuType()));

        assertTrue(hasOverview, "OVERVIEW sub-menu content must exist");
        assertTrue(hasUsage, "USAGE sub-menu content must exist");
        assertTrue(hasProsCons, "PROS_CONS sub-menu content must exist");
        assertTrue(hasBenchmarks, "BENCHMARKS sub-menu content must exist");
        assertTrue(hasLinks, "LINKS sub-menu content must exist");
    }

    @Test
    @DisplayName("MyBatis MetricMapper XML test")
    void testMetricMapper() {
        LlmModel r1 = llmService.getModelDetailsByKey("deepseek-r1");
        assertNotNull(r1);
        assertNotNull(r1.getMetrics());
        assertFalse(r1.getMetrics().isEmpty());
    }
}
