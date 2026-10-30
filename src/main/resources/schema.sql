DROP TABLE IF EXISTS model_metrics;
DROP TABLE IF EXISTS model_contents;
DROP TABLE IF EXISTS llm_models;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(50),
    tagline VARCHAR(255),
    display_order INT DEFAULT 0
);

CREATE TABLE llm_models (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category_id BIGINT NOT NULL,
    model_key VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    provider VARCHAR(100) NOT NULL,
    release_date VARCHAR(50),
    context_window VARCHAR(50),
    max_output VARCHAR(50),
    pricing_input VARCHAR(50),
    pricing_output VARCHAR(50),
    badge VARCHAR(50),
    tagline VARCHAR(255),
    display_order INT DEFAULT 0,
    CONSTRAINT fk_model_category FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
);

CREATE TABLE model_contents (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    model_id BIGINT NOT NULL,
    sub_menu_type VARCHAR(50) NOT NULL, -- OVERVIEW, USAGE, PROS_CONS, BENCHMARKS, LINKS
    title VARCHAR(200) NOT NULL,
    content_body TEXT NOT NULL,
    meta_json TEXT,
    CONSTRAINT fk_content_model FOREIGN KEY (model_id) REFERENCES llm_models (id) ON DELETE CASCADE
);

CREATE TABLE model_metrics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    model_id BIGINT NOT NULL,
    benchmark_name VARCHAR(100) NOT NULL,
    score VARCHAR(50) NOT NULL,
    percent_val INT DEFAULT 0,
    category VARCHAR(50),
    CONSTRAINT fk_metric_model FOREIGN KEY (model_id) REFERENCES llm_models (id) ON DELETE CASCADE
);
