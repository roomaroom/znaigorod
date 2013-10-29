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
    end
  end

  def vk_meta(item, url, img_path)
    image = image_direct_url(img_path)
    res = ""
    res << "<meta property='og:description' content='#{I18n.t("meta.#{item}.description")}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('meta.default.title')}' />\n"
    res << "<meta property='og:title' content='#{I18n.t("meta.#{item}.title")}' />\n"
    res << "<meta property='og:url' content='#{url}' />\n"
    res << "<meta property='og:image' content='#{image}' />\n"
    res << "<meta name='image' content='#{image}' />\n"
    res << "<link rel='image_src' href='#{image}' />\n"
    res.html_safe
  end
end
