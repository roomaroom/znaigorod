$ ->
  init_datetime_picker()

  init_new_affiche() if $('.dropdown').length
  init_choose_file() if $('.choose_file').length
  init_autosuggest_handler() if $('.autosuggest').length
  init_choose_coordinate() if $('.choose_coordinate').length
  init_vk_token() if $('.form_view.vk_token').length
  init_saunas() if $('#sauna_tabs').length
  init_menu_handler() if $('.input_with_image').length
  init_has_virtual_tour() if $('.virtual_tour_fields').length
  init_address() if $('.address_fields').length
  init_curtail() if $('.curtail').length
  init_file_upload() if $('.file_upload').length
  init_ajax_delete() if $('.ajax_delete').length
  init_crop()
  init_webcam() if $('#webcam_snapshot_image').length
  init_webcam_map() if $('#webcam_map').length
  init_accounts_for_lottery() if $('.accounts_for_lottery').length
  init_markitup() if $('.discount .markitup').length
  init_offers() if $('.offers').length
  init_contest() if $('#contest_og_image').length
  init_organization() if $('.sections').length
  init_photogallery() if $('#photogallery_og_image').length
  initMyReviews() if $('.review_form').length
  initPromoteAfisha() if $('.promoted_link').length
  initEditAttachmentDescription() if $('.js-gallery .js-edit-attachment-description').length
  mainPageReviewsAutocomplete() if $('.js-main_page_reviews_autocomplete').length
  mainPagePostersAutocomplete() if $('.js-main_page_afishas_autocomplete').length
  init_kinopoisk() if $('form.new_afisha, form.edit_afisha')
  loadRelatedAfishas() if $('.relations').length
  initMyDiscount() if $('.js-toggle-forms').length

$(window).load ->
  init_organization_map() if $('.edit_organization, .new_organization').length
  init_discount_map() if $('.discount').length
