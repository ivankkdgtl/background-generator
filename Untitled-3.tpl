<div class="thumbs">  
	<div class="container"> 
		{{if $list_videos_hide_headline!='true'}}
			<div class="heading cfx">
				<h{{$list_videos_header_level|default:"2"}} class="title">{{$list_videos_title|mb_ucfirst}}{{if $nav.page_now>1}}{{$lang.common_list.paginated_postfix|replace:"%1%":$nav.page_now}}{{/if}}</h{{$list_videos_header_level|default:"2"}}>

				{{assign var="base_url" value=$lang.urls.videos}}
				{{if $list_type=='tags'}}
					{{assign var="base_url" value=$lang.urls.videos_by_tag|replace:"%DIR%":$tag_info.tag_dir|replace:"%ID%":$tag_info.tag_id}}
				{{elseif $list_type=='categories'}}
					{{assign var="base_url" value=$lang.urls.videos_by_category|replace:"%DIR%":$category_info.dir|replace:"%ID%":$category_info.category_id}}
				{{elseif $list_type=='models'}}
					{{assign var="base_url" value=$lang.urls.videos_by_model|replace:"%DIR%":$model_info.dir|replace:"%ID%":$model_info.model_id}}
				{{elseif $list_type=='dvds'}}
					{{assign var="base_url" value=$lang.urls.videos_by_dvd|replace:"%DIR%":$dvd_info.dir|replace:"%ID%":$dvd_info.dvd_id}}
				{{elseif $list_type=='search'}}
					{{assign var="query_url" value=$search_keyword|replace:" ":"-"|replace:"&":"%26"|replace:"?":"%3F"|replace:"/":"%2F"|rawurlencode}}
					{{assign var="base_url" value=$lang.urls.search_query_videos|replace:"%QUERY%":$query_url}}
				{{/if}}

				{{if $list_videos_show_sorting=='true'}}
					{{if count($data)>0}}
						<div class="buttons pull-right">
							{{if $list_type=='search' && $sort_by!='relevance'}}
								<a href="{{$base_url}}" class="btn">{{$lang.videos.list_sorting.relevance}}</a>
							{{/if}}
							{{foreach from=$lang.videos.sortings item="item"}}
								{{if $sort_by!=$item || $sort_by=='rating' || $sort_by=='video_viewed'}}
									{{if $item=='rating' && count($lang.videos.sortings_top_rated)>0}}
										<div class="dropdown__block">
											<button class="btn" data-action="drop" data-drop-id="rating_sort_drop_{{$block_uid}}">{{$lang.videos.list_sorting[$item]}}</button>
											<div class="dropdown__block__menu" id="rating_sort_drop_{{$block_uid}}">
												<nav>
													<ul class="drop-inner">
														{{foreach from=$lang.videos.sortings_top_rated item="item2"}}
															{{if $sort_by!=$item2}}
																<li>
																	<a href="{{$base_url}}?by={{$item2}}">{{$lang.videos.list_sorting_period[$item2]}}</a>
																</li>
															{{/if}}
														{{/foreach}}
													</ul>
												</nav>
											</div>
										</div>
									{{elseif $item=='video_viewed' && count($lang.videos.sortings_most_popular)>0}}
										<div class="dropdown__block">
											<button class="btn" data-action="drop" data-drop-id="views_sort_drop_{{$block_uid}}">{{$lang.videos.list_sorting[$item]}}</button>
											<div class="dropdown__block__menu" id="views_sort_drop_{{$block_uid}}">
												<nav>
													<ul class="drop-inner">
														{{foreach from=$lang.videos.sortings_most_popular item="item2"}}
															{{if $sort_by!=$item2}}
																<li>
																	<a href="{{$base_url}}?by={{$item2}}">{{$lang.videos.list_sorting_period[$item2]}}</a>
																</li>
															{{/if}}
														{{/foreach}}
													</ul>
												</nav>
											</div>
										</div>
									{{else}}
										<a href="{{$base_url}}?by={{$item}}" class="btn">{{$lang.videos.list_sorting[$item]}}</a>
									{{/if}}
								{{/if}}
							{{/foreach}}
						</div>
					{{/if}}
				{{elseif $mode_favourites=='1'}}
					<div class="buttons pull-right">
						{{foreach item="item" from=$lang.videos.predefined_favourites}}
							{{if $fav_type!=$item}}
								<a href="{{$lang.urls.memberzone_my_fav_videos}}?fav_type={{$item}}" class="btn">{{$lang.videos.list_switch_favourites[$item]}} ({{$favourites_summary[$item].amount|default:"0"}})</a>
							{{/if}}
						{{/foreach}}
						<div class="dropdown__block align-right">
							<button class="btn" data-action="drop" data-drop-id="playlists_drop_{{$block_uid}}">{{$lang.memberzone.profile_my_fav_videos_playlists}}</button>
							<div class="dropdown__block__menu" id="playlists_drop_{{$block_uid}}">
								<nav class="wide">
									<ul class="drop-inner">
										{{foreach item="item" from=$playlists}}
											<li>
												<a href="{{$lang.urls.memberzone_my_playlist|replace:"%ID%":$item.playlist_id}}" {{if $playlist_id==$item.playlist_id}}active{{/if}}">{{$item.title}} ({{$item.total_videos}})</a>
											</li>
										{{/foreach}}
										<li>
											<a data-action="popup" href="{{$lang.urls.memberzone_create_playlist}}">{{$lang.memberzone.profile_my_fav_videos_playlists_create}}</a>
										</li>
									</ul>
								</nav>
							</div>
						</div>
					</div>
				{{/if}}
			</div>
		{{/if}}

		{{if $can_manage==1 && $mode_favourites==1}}
			<form data-form="list" data-block-id="{{$block_uid}}" data-prev-url="{{$nav.previous}}">
				<div class="generic-error {{if $playlist_info.is_locked==0}}hidden{{/if}}">
					{{if $playlist_info.is_locked==1}}
						{{$lang.validation.common.playlist_locked}}
					{{/if}}
				</div>
		{{/if}}
		{{if count($data)>0}}
			<div class="thumbs__list cfx new">
				{{foreach item="item" from=$data name="videos_list"}}
					<div class="item-padd {{if $user_login=='1'}}user-login{{/if}}">
						<div class="item thumb thumb--videos" data-hover="true">
							<a {{if $tour=='1'}}href="{{$config.statics_url}}/join/"{{elseif $mode_favourites==1 && $playlist_id>0}}href="{{$lang.urls.memberzone_my_playlist_view|replace:"%ID%":$playlist_id|replace:"%VIDEO%":$item.video_id}}"{{elseif $item.view_page_url!=''}}href="{{$item.view_page_url}}"{{/if}} title="{{$item.title}}" {{if $item.rotator_params!=''}}data-rt="{{$item.rotator_params|replace:"pqr=":""}}"{{/if}}>
								<div class="img">
									<img src="{{$item.screen_url|replace:'https://cdn1.raweuro.com':''}}/{{if $custom_format}}{{$custom_format}}{{else}}{{$lang.videos.thumb_size}}{{/if}}/{{$item.screen_main}}.jpg" alt="{{$item.title}}" {{if $lang.enable_thumb_scrolling=='true'}}data-cnt="{{$item.screen_amount}}"{{/if}} {{if $item.is_private==0 && $item.formats[$lang.videos.preview_video_format_standard].file_path!=''}}data-preview="{{$config.project_url}}/get_file/{{$item.server_group_id}}/{{$item.formats[$lang.videos.preview_video_format_standard].file_path}}/"{{/if}} {{if $item.is_private==2 && $item.formats[$lang.videos.preview_video_format_premium].file_path!=''}}data-preview="{{$config.project_url}}/get_file/{{$item.server_group_id}}/{{$item.formats[$lang.videos.preview_video_format_premium].file_path}}/"{{/if}} />
									{{*width="{{$lang.videos.thumb_size|geomsize:'width'}}" height="{{$lang.videos.thumb_size|geomsize:'height'}}"*}}
									<span class="duration">{{$item.duration_array.text}}</span>
								</div>
								<div class="thumb__info">
									<div class="thumb-spot">
										{{assign var="video_rating" value="`$item.rating/5*100`"}}
										{{if $video_rating>100}}{{assign var="video_rating" value="100"}}{{/if}}
										<div class="thumb-spot__text">
											<h5 class="thumb-spot__title">
												{{if $lang.videos.truncate_title_to>0}}
													{{$item.title|truncate:$lang.videos.truncate_title_to:"...":true}}
												{{else}}
													{{$item.title}}
												{{/if}}
											</h5>
											<div class="models">
												{{foreach item="model" from=$item.models name="models"}}
													{{if $smarty.foreach.models.iteration<=2}}
														<a class="link" href="{{if $smarty.session.user_id>0}}//ma.raweuro.com/models/{{$model.dir}}/{{else}}{{$config.statics_url}}/models/{{$model.dir}}/{{/if}}">{{$model.title}} </a>
													{{/if}}
												{{/foreach}}
											</div>
											<ul class="thumb-spot__data">
												<li>{{$item.post_date|date_format:$lang.global.date_format}}</li>
												{{assign var="video_views" value=$item.video_viewed|number_format:0:",":$lang.global.number_format_delimiter}}
												<li>{{$lang.videos.list_label_views|replace:"%1%":$video_views}}</li>
												<div class="thumb-spot__rating rotated"><span>{{$video_rating|string_format:"%d"}}%</span><i class="icon-like-shape-15"></i></div>
											</ul>
										</div>
									</div>
								</div>
							</a>
							{{if $can_manage==1 && $mode_favourites==1}}
								<label class="checkbox__fav-label"></label>
								<input type="checkbox" class="checkbox checkbox__fav" name="delete[]" data-action="select" value="{{$item.video_id}}" {{if $playlist_info.is_locked==1}}disabled{{/if}}>
								<div class="fav_overlay"></div>
							{{/if}}
						</div>
					</div>
					{{if $smarty.foreach.videos_list.index == 6 && $list_videos_show_advertisement=='true'}}
						{{include file="include_join_banner_2.tpl"}}
					{{/if}}
				{{/foreach}}
			</div>
		{{else}}
            <div class="item padd">
			<div class="img"><img src="https://m4g4d5u7.ssl.hwcdn.net/contents/empty/csv1.jpg"></div></div>
		{{/if}}
		{{if $can_manage==1 && $mode_favourites==1}}
			<div>
				{{if $mode_favourites==1}}
					<input type="hidden" name="function" value="get_block"/>
					<input type="hidden" name="block_id" value="{{$block_uid}}"/>
					<input type="hidden" name="action" value="delete_from_favourites"/>
					<input type="hidden" name="fav_type" value="{{$fav_type}}"/>
					<input type="hidden" name="playlist_id" value="{{$playlist_id|default:"0"}}"/>
				{{/if}}
				{{if count($data)>0}}
					<input type="button" class="btn" value="{{$lang.videos.list_action_select_all}}" data-action="select_all"/>
					<input type="button" class="btn" value="{{$lang.videos.list_action_delete_selected}}" disabled data-mode="selection" data-action="delete_multi" data-confirm="{{$lang.videos.list_action_delete_selected_confirm_favourites}}">
					<input type="button" class="btn" value="{{$lang.videos.list_action_move_to_playlist}}" disabled data-mode="selection" data-action="move_multi" data-href="{{$lang.urls.memberzone_select_playlist}}?playlist_id={{$playlist_id|default:"0"}}">
				{{/if}}
				{{if $playlist_id>0}}
					<input type="button" class="btn" value="{{$lang.videos.list_action_delete_playlist}}" {{if $playlist_info.is_locked==1}}disabled{{/if}} data-action="delete_playlist" data-id="{{$playlist_id}}" data-confirm="{{$lang.videos.list_action_delete_playlist_confirm|replace:"%1%":$playlist}}" data-redirect-url="{{$lang.urls.memberzone_my_fav_videos}}">
					<input type="button" class="btn" value="{{$lang.videos.list_action_edit_playlist}}" data-action="popup" data-href="{{$lang.urls.memberzone_edit_playlist|replace:"%ID%":$playlist_id}}">
				{{/if}}
			</div>
			</form>
		{{/if}}
	</div>
</div>