<?php
/**
 * @package tawk.to Integration
 * @author tawk.to
 * @copyright (C) 2021 tawk.to
 * @license GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */
?><?php echo $header; ?>
<link href="https://plugins.tawk.to/public/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">
.form-group + .form-group {
    border: none;
    margin: 0px 0;
}
.attrib_desc {
    color: #aaa;
    font-weight: normal;
    font-size: 13px;
    font-style: italic;
}

#optionsSuccessMessage {
    position: absolute;
    background-color: #dff0d8;
    color: #3c763d;
    border-color: #d6e9c6;
    font-weight: bold;
    display: none;
}

@media only screen and (max-width: 1200px) {
    #optionsSuccessMessage {
        position: relative;
        margin-top: 1rem;
    }
}
</style>
<?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
        <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
        </ul>
        </div>
    </div>
    <div class="container-fluid">
        <div class="box">
            <div class="heading">
                <h1><img src="view/image/tawkto/tawky.png" alt="" /> <?php echo $heading_title; ?></h1>
            </div>
            <div class="box">
                <?php if (!$same_user) : ?>
                <div id="widget_already_set" style="width: 100%;color: #3c763d; border-color: #d6e9c6; font-weight: bold; margin: 20px 0 30px;" class="alert alert-warning">Notice: Widget already set by other user</div>
                <?php endif; ?>
            </div>
            <div class="content" style="position: relative;min-height: 330px;">
                <div id="loader" style="position: absolute; top : 50%; left : 50%; margin-top : -35px; margin-left: -35px;">
                    <img src="view/image/tawkto/loader.gif" alt="" />
                </div>
                <iframe id="tawkIframe" src="" style="min-height: 305px; width : 100%; border: none; display: none">
                </iframe>
                <input type="hidden" class="hidden widget_vars" name="page_id" value="<?php echo (!is_null($widget_config['page_id']))?$widget_config['page_id']:0; ?>">
                <input type="hidden" class="hidden widget_vars" name="widget_id" value="<?php echo (!is_null($widget_config['widget_id']))?$widget_config['widget_id']:0; ?>">
                <input type="hidden" class="hidden widget_vars" name="store_id" value="<?php echo $store_id?>">
                <input type="hidden" class="hidden widget_vars" name="store_layout_id" value="<?php echo $store_layout_id?>">
            </div>
        </div>
        <hr>
        <div class="box">
            <div class="row">
                <div class="col-lg-8">
                    <form id="module_form" class="form-horizontal" action="" method="post">
                        <div class="col-lg-12">
                            <div class="panel-heading"><strong>Visibility Settings</strong></div>
                        </div>
                        <div class="form-group col-lg-12">
                            <label for="always_display" class="col-lg-6 control-label">Always show tawk.to widget on every page</label>
                            <div class="col-lg-6 control-label ">
                                <input type="checkbox" class="col-lg-6" name="always_display"
                                    id="always_display" value="1" <?php echo ($display_opts['always_display'])?'checked':'';?> />
                            </div>
                        </div>
                        <div class="form-group col-lg-12">
                            <label for="hide_oncustom" class="col-lg-6 control-label">Except on pages:</label>
                            <div class="col-lg-6 control-label">
                                <?php if (!empty($display_opts['hide_oncustom'])) : ?>
                                    <?php $whitelist = json_decode($display_opts['hide_oncustom']) ?>
                                    <textarea class="form-control hide_specific" name="hide_oncustom"
                                        id="hide_oncustom" cols="30" rows="10"><?php foreach ($whitelist as $page) { echo $page."\r\n"; } ?></textarea>
                                <?php else : ?>
                                    <textarea class="form-control hide_specific" name="hide_oncustom" id="hide_oncustom" cols="30" rows="10"></textarea>
                                <?php endif; ?>
                                <br>
                                <p style="text-align: justify;">
                                Add URLs to pages in which you would like to hide the widget. ( if "always show" is checked )<br>
                                Put each URL in a new line.
                                </p>
                            </div>
                        </div>
                        <div class="form-group col-lg-12">
                            <label for="show_onfrontpage" class="col-lg-6 control-label">Show on frontpage</label>
                            <div class="col-lg-6 control-label ">
                                <input type="checkbox" class="col-lg-6 show_specific" name="show_onfrontpage"
                                    id="show_onfrontpage" value="1"
                                    <?php echo ($display_opts['show_onfrontpage'])?'checked':'';?> />
                            </div>
                        </div>
                        <div class="form-group col-lg-12">
                            <label for="show_oncategory" class="col-lg-6 control-label">Show on category pages</label>
                            <div class="col-lg-6 control-label ">
                                <input type="checkbox" class="col-lg-6 show_specific" name="show_oncategory" id="show_oncategory" value="1"
                                    <?php echo ($display_opts['show_oncategory'])?'checked':'';?>  />
                            </div>
                        </div>
                        <div class="form-group col-lg-12">
                            <label for="show_oncustom" class="col-lg-6 control-label">Show on pages:</label>
                            <div class="col-lg-6 control-label">
                                <?php if (!empty($display_opts['show_oncustom'])) : ?>
                                    <?php $whitelist = json_decode($display_opts['show_oncustom']) ?>
                                    <textarea class="form-control show_specific" name="show_oncustom"
                                        id="show_oncustom" cols="30" rows="10"><?php foreach ($whitelist as $page) { echo $page."\r\n"; } ?></textarea>
                                <?php else : ?>
                                    <textarea class="form-control show_specific" name="show_oncustom" id="show_oncustom" cols="30" rows="10"></textarea>
                                <?php endif; ?>
                                <br>
                                <p style="text-align: justify;">
                                Add URLs to pages in which you would like to show the widget.<br>
                                Put each URL in a new line.
                                </p>
                            </div>
                        </div>
                        <br><br>
                        <div class="col-lg-12">
                            <div class="panel-heading"><strong>Cart Integration</strong></div>
                        </div>
                        <div class="form-group col-lg-12">
                            <label for="monitor_customer_cart" class="col-lg-6 control-label">
                            Monitor items added to cart
                            <br>
                            <span class="attrib_desc">Enable sending of product details to tawk.to dashboard when an item is added to cart.</span>
                            </label>
                            <div class="col-lg-6 control-label ">
                                <input type="checkbox" class="col-lg-6 " name="monitor_customer_cart" id="monitor_customer_cart" value="1"
                                    <?php echo ($display_opts['monitor_customer_cart'])?'checked':'';?>  />
                            </div>
                        </div>
                        <br><br>
                        <div class="col-lg-12">
                            <div class="panel-heading"><strong>Privacy Options</strong></div>
                        </div>
                        <div class="form-group col-lg-12">
                            <label for="enable_visitor_recognition" class="col-lg-6 control-label">
                            Enable Visitor Recognition
                            <br>
                            <span class="attrib_desc">Enable sending of customer details to tawk.to dashboard when the customer is logged in.</span>
                            </label>
                            <div class="col-lg-6 control-label ">
                                <input type="checkbox" class="col-lg-6 " name="enable_visitor_recognition" id="enable_visitor_recognition" value="1"
                                    <?php echo ($display_opts['enable_visitor_recognition'])?'checked':'';?>  />
                            </div>
                        </div>
                        <div class="form-group col-lg-12">
                            <div class="col-lg-6 col-xs-12">
                                <button type="submit" value="1" id="module_form_submit_btn" name="submitBlockCategories" class="btn btn-default pull-right"><i class="process-icon-save"></i> Save</button>
                            </div>
                            <div class="col-lg-6 col-xs-12">
                                <div id="optionsSuccessMessage"
                                    class="alert alert-success col-lg-12">
                                    Successfully set widget options to your site
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="col-lg-4"></div>
            </div>
        </div>
    </div>
</div>

<script>
var currentHost = window.location.protocol + '//' + window.location.host,
url = '<?php echo $iframe_url ?>&pltf=opencart&pltfv=2&parentDomain=' + currentHost,
baseUrl = '<?php echo $base_url ?>',
storeHierarchy = <?php echo json_encode($hierarchy) ?>;

jQuery('#tawkIframe').attr('src', url);
jQuery('#tawkIframe').load(function() {
    $('#loader').hide();
    $(this).show();
});
var iframe = jQuery('#tawk_widget_customization')[0];

window.addEventListener('message', function(e) {

    if(e.origin === baseUrl) {

        if(e.data.action === 'setWidget') {
            setTawkWidget(e);
        }

        if(e.data.action === 'removeWidget') {
            removeTawkWidget(e);
        }

        if(e.data.action === 'getIdValues') {
            e.source.postMessage({action: 'idValues', values : storeHierarchy}, baseUrl);
        }

        if(e.data.action === 'reloadHeight') {
            reloadIframeHeight(e.data.height);
        }
    }
});

function reloadIframeHeight(height) {
    if (!height) {
        return;
    }

    var iframe = jQuery('#tawkIframe');
    if (height === iframe.height()) {
        return;
    }

    iframe.height(height);
}

function setTawkWidget(e) {
    var store_layout = e.data.id;
    jQuery.post('<?php echo $url['set_widget_url']; ?>', {
        pageId   : e.data.pageId,
        widgetId : e.data.widgetId,
        id       : e.data.id,
        store     : parseInt(store_layout),
        store_layout : e.data.id
    }, function(r) {
        if(r.success) {
            e.source.postMessage({action: 'setDone'}, baseUrl);

            jQuery('input[name="page_id"]').val(e.data.pageId);
            jQuery('input[name="widget_id"]').val(e.data.widgetId);
            var newval = parseInt(store_layout);
            jQuery('input[name="store_id"]').val(newval);
            jQuery('input[name="store_layout_id"]').val(e.data.id);
        } else {
            e.source.postMessage({action: 'setFail'}, baseUrl);
        }
    });
}

function removeTawkWidget(e) {
    var store_layout = e.data.id;
    jQuery.post('<?php echo $url['remove_widget_url']; ?>', {
        id : e.data.id,
        store : parseInt(store_layout),
        store_layout : e.data.id,
    }, function(r) {
        if(r.success) {
            e.source.postMessage({action: 'removeDone'}, baseUrl);

            jQuery('.widget_vars').val();
        } else {
            e.source.postMessage({action: 'removeFail'}, baseUrl);
        }

    });
}
jQuery(document).ready(function() {
    if(jQuery("#always_display").prop("checked")){
        jQuery('.show_specific').prop('disabled', true);
    } else {
        jQuery('.hide_specific').prop('disabled', true);
    }

    jQuery("#always_display").change(function() {
        if(this.checked){
            jQuery('.hide_specific').prop('disabled', false);
            jQuery('.show_specific').prop('disabled', true);
        }else{
            jQuery('.hide_specific').prop('disabled', true);
            jQuery('.show_specific').prop('disabled', false);
        }
    });

    // process the form
    jQuery('#module_form').submit(function(event) {
        $path = '<?php echo $url['set_options_url']; ?>';
        jQuery.post($path, {
            action     : 'set_visibility',
            ajax       : true,
            page_id    : jQuery('input[name="page_id"]').val(),
            widget_id  : jQuery('input[name="widget_id"]').val(),
            store      : parseInt(jQuery('input[name="store_layout_id"]').val()),
            options    : jQuery(this).serialize()
        }, function(r) {
            if(r.success) {
                $('#optionsSuccessMessage').toggle().delay(3000).fadeOut();
            }
        });

        // stop the form from submitting the normal way and refreshing the page
        event.preventDefault();
    });
});
</script>

<?php echo $footer; ?>
