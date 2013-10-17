# encoding: utf-8

class AccountDecorator < ApplicationDecorator
  decorates :account

  def title
    "#{first_name} #{last_name}"
  end

  def show_url
    h.account_url(account)
  end

  def image
    h.resized_image_url(account.avatar.url, 88, 88)
  end

  def buddies
    friends.approved.map(&:friendable).first(5)
  end

  def tags_for_vk
    res = ""
    vk_image = h.asset_path('vk_logotype.png')
    res << "<meta property='og:description' content='Ты можешь найти компанию для любого мероприятия и времяпрепровождения. Посмотри, сколько людей приглашают сходить куда-нибудь, а сколько ждут приглашения!'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('meta.default.title')}' />\n"
    res << "<meta property='og:title' content='Знакомтсва на ЗнайГород' />\n"
    res << "<meta property='og:url' content='#{show_url}' />\n"
    res << "<meta property='og:image' content='#{vk_image}' />\n"
    res << "<meta name='image' content='#{vk_image}' />\n"
    res << "<link rel='image_src' href='#{vk_image}' />\n"
    res.html_safe
  end
end
