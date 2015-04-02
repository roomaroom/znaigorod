class RemoveColumnsWithCacheInSectionPages < ActiveRecord::Migration
  def change
    remove_columns :section_pages, :cached_content_for_index, :cached_content_for_show
  end
end
