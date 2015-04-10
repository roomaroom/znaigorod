# encoding: utf-8

module ShareVkHelper
  include ImageHelper

  def data_attachments(item)
    if item.is_a?(Afisha)
      "#{item.poster_vk_id},#{afisha_show_url(item)}"
    elsif item.is_a?(Discount)
      "#{item.poster_vk_id},#{discount_url(item)}"
    elsif item.is_a?(Organization)
      "#{item.poster_vk_id},#{organization_url(item)}"
    elsif item.is_a?(Question)
      "#{item.poster_vk_id},#{question_url(item)}"
    elsif item.is_a?(Review)
      "#{item.poster_vk_id},#{review_url(item)}"
    end
  end

  def vk_meta(item, url, img_path)
    image = image_direct_url(img_path)
    res = ""
    res << "<meta property='og:description' content='#{I18n.t("meta.#{Settings['app.city']}.#{item}.description")}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t("meta.#{Settings['app.city']}.default.title")}' />\n"
    res << "<meta property='og:title' content='#{I18n.t("meta.#{Settings['app.city']}.#{item}.title")}' />\n"
    res << "<meta property='og:url' content='#{url}' />\n"
    res << "<meta property='og:image' content='#{image}' />\n"
    res << "<link rel='image_src' href='#{image}' />\n"
    res.html_safe
  end
end
