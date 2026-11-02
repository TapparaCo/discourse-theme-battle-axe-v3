# frozen_string_literal: true

RSpec.describe "Topic list columns" do
  fab!(:category)
  fab!(:topic) { Fabricate(:topic, category:) }

  before { upload_theme }

  it "replaces posters with category and latest post columns on desktop" do
    visit "/latest"

    expect(page).to have_css(".topic-list-item td.activity .latest-info .name")
    expect(page).to have_css(".topic-list-item td.category .badge-category__wrapper")

    columns =
      all(".topic-list thead th").map do |th|
        th[:class].split & %w[default category views posts activity posters]
      end
    expect(columns).to eq([%w[default], %w[category], %w[views], %w[posts], %w[activity]])
  end
end
