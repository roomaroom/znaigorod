[1;33mdiff --git i/app/assets/stylesheets/public/_discount_posters.sass w/app/assets/stylesheets/public/_discount_posters.sass[m
[1;33mindex 82dba36..8cef853 100644[m
[1;33m--- i/app/assets/stylesheets/public/_discount_posters.sass[m
[1;33m+++ w/app/assets/stylesheets/public/_discount_posters.sass[m
[1;35m@@ -18,6 +18,7 @@[m
 [m
   .button_pagination[m
     clear: both[m
[32m+[m
     li[m
       float: left[m
       margin: 0 10px 20px 10px[m
[1;33mdiff --git i/app/assets/stylesheets/public/_suborganization_show.sass w/app/assets/stylesheets/public/_suborganization_show.sass[m
[1;33mindex ef30801..f4a576f 100644[m
[1;33m--- i/app/assets/stylesheets/public/_suborganization_show.sass[m
[1;33m+++ w/app/assets/stylesheets/public/_suborganization_show.sass[m
[1;35m@@ -12,7 +12,7 @@[m [mbody .suborganization_information_wrapper,[m
     +clearfix[m
     margin: 15px 0[m
 [m
[31m-    &.afisha-paginator[m
[32m+[m[32m    &.button_pagination[m
       clear: none !important[m
 [m
       li.pagination[m
[1;35m@@ -22,7 +22,7 @@[m [mbody .suborganization_information_wrapper,[m
         padding: 0 0 20px 0 !important[m
         width: 640px !important[m
 [m
[31m-    .posters[m
[32m+[m[32m    .afisha_posters[m
       margin: 0 auto[m
       width: 660px[m
 [m
[1;33mdiff --git i/app/controllers/discounts_controller.rb w/app/controllers/discounts_controller.rb[m
[1;33mindex 38ad07d..c6af7c6 100644[m
[1;33m--- i/app/controllers/discounts_controller.rb[m
[1;33m+++ w/app/controllers/discounts_controller.rb[m
[1;35m@@ -7,7 +7,7 @@[m [mclass DiscountsController < ApplicationController[m
 [m
     respond_to do |format|[m
       format.html {[m
[31m-        @presenter = DiscountsPresenter.new(params.merge(:with_advertisement => true))[m
[32m+[m[32m        @presenter = DiscountsPresenter.new(params)[m
         @discounts = @presenter.decorated_collection[m
 [m
         render partial: 'discounts/discount_posters', layout: false and return if request.xhr?[m
[1;33mdiff --git i/app/presenters/discounts_presenter.rb w/app/presenters/discounts_presenter.rb[m
[1;33mindex 433c43b..50c772c 100644[m
[1;33m--- i/app/presenters/discounts_presenter.rb[m
[1;33m+++ w/app/presenters/discounts_presenter.rb[m
[1;35m@@ -163,8 +163,7 @@[m [mclass DiscountsPresenter[m
   end[m
 [m
   attr_accessor :type, :kind, :organization_id,[m
[31m-                :order_by, :page, :per_page, :q,[m
[31m-                :advertisement, :with_advertisement[m
[32m+[m[32m                :order_by, :page, :per_page, :q[m
 [m
   attr_reader :type_filter, :kind_filter, :order_by_filter[m
 [m
[1;35m@@ -174,11 +173,6 @@[m [mclass DiscountsPresenter[m
     normalize_args[m
     store_parameters[m
     initialize_filters[m
[31m-    initialize_advertisement[m
[31m-  end[m
[31m-[m
[31m-  def initialize_advertisement[m
[31m-    @advertisement = Advertisement.new(list: 'discount', page: @page)[m
   end[m
 [m
   def collection[m
[1;35m@@ -189,20 +183,12 @@[m [mclass DiscountsPresenter[m
     searcher.total_count[m
   end[m
 [m
[31m-  def with_advertisement?[m
[31m-    with_advertisement[m
[32m+[m[32m  def current_count[m
[32m+[m[32m    total_count-(@page.to_i*@per_page)[m
   end[m
 [m
   def decorated_collection[m
[31m-    @decorated_collection ||= begin[m
[31m-                                list = collection.map { |item| DiscountDecorator.decorate item }[m
[31m-[m
[31m-                                advertisement.places_at(page).each do |ad|[m
[31m-                                  list.insert(ad.position, ad)[m
[31m-                                end if with_advertisement?[m
[31m-[m
[31m-                                list[m
[31m-                              end[m
[32m+[m[32m    @decorated_collection ||= collection.map { |item| DiscountDecorator.decorate item }[m
   end[m
 [m
   def page_title[m
[1;35m@@ -221,7 +207,7 @@[m [mclass DiscountsPresenter[m
 [m
   def normalize_args[m
     @page     ||= 1[m
[31m-    @per_page ||= per_page.to_i.zero? ? 15 : per_page.to_i[m
[32m+[m[32m    @per_page ||= per_page.to_i.zero? ? 20 : per_page.to_i[m
   end[m
 [m
   def store_parameters[m
[1;35m@@ -240,7 +226,6 @@[m [mclass DiscountsPresenter[m
       params[:kind]             = kind_filter.selected[m
       params[:organization_ids] = [Parameters.instance.organization_id] if Parameters.instance.organization_id?[m
       params[:q]                = q if q.present?[m
[31m-      params[:without]          = advertisement.discounts if with_advertisement?[m
     end[m
   end[m
 [m
[1;33mdiff --git i/app/views/discounts/_discount_posters.html.erb w/app/views/discounts/_discount_posters.html.erb[m
[1;33mindex 9fea8c7..b54e0f2 100644[m
[1;33m--- i/app/views/discounts/_discount_posters.html.erb[m
[1;33m+++ w/app/views/discounts/_discount_posters.html.erb[m
[1;35m@@ -2,8 +2,15 @@[m
   <%= render :partial => 'discounts/discount_poster', :locals => { :discount => discount, :@width => '200', :@height => '164' } %>[m
 <% end %>[m
 [m
[32m+[m[32m<% unless @presenter.collection.last_page? %>[m
[32m+[m[32m  <li class="item pagination">[m
[32m+[m[32m    <%= link_to_next_page @presenter.collection, "Еще организации (#{@presenter.current_count})", :remote => true, :class => 'js-next-page btn btn-block btn-grey btn-lg', :params => params %>[m
[32m+[m[32m  </li>[m
[32m+[m[32m<% end %>[m
[32m+[m
 <% if @presenter.collection.current_page == 1 %>[m
   <li class="google-ads-item">[m
     <%= render :partial => 'commons/ads_by_google' %>[m
   </li>[m
 <% end %>[m
[41m+[m
[1;33mdiff --git i/app/views/discounts/index.html.erb w/app/views/discounts/index.html.erb[m
[1;33mindex 4a83093..b5fbd35 100644[m
[1;33m--- i/app/views/discounts/index.html.erb[m
[1;33m+++ w/app/views/discounts/index.html.erb[m
[1;35m@@ -41,7 +41,7 @@[m
   </div>[m
 [m
   <div class="button_pagination">[m
[31m-    <ul class="discount_posters">[m
[32m+[m[32m    <ul class="discount_posters js-paginable-list">[m
       <%= render :partial => 'discounts/discount_posters', :locals => { :collection => @presenter.collection } %>[m
     </ul>[m
   </div>[m
[1;33mdiff --git i/app/views/organizations/_organizations_posters.html.erb w/app/views/organizations/_organizations_posters.html.erb[m
[1;33mindex 492e9ad..5cbf844 100644[m
[1;33m--- i/app/views/organizations/_organizations_posters.html.erb[m
[1;33m+++ w/app/views/organizations/_organizations_posters.html.erb[m
[1;35m@@ -6,7 +6,7 @@[m
 [m
 <% unless @presenter.collection.last_page? %>[m
   <li class="item pagination">[m
[31m-    <%= link_to_next_page @presenter.paginated_collection, "Еще организации (#{@presenter.current_count})", :remote => true, :class => 'js-next-page btn btn-block btn-grey btn-lg', :params => params %>[m
[32m+[m[32m    <%= link_to_next_page @presenter.collection, "Еще организации (#{@presenter.current_count})", :remote => true, :class => 'js-next-page btn btn-block btn-grey btn-lg', :params => params %>[m
   </li>[m
 <% end %>[m
 [m
