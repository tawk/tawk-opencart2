<?php
/**
 * @package Tawk.to Integration
 * @author Tawk.to
 * @copyright (C) 2014- Tawk.to
 * @license GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */
?>

<?php echo $header; ?>
<?php echo $column_left; ?>


<div id="content">
	<ul class="breadcrumb">
		<?php foreach ($breadcrumbs as $breadcrumb) { ?>
    	<li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
    	<?php } ?>
	</ul>
	<div class="box">
		<div class="heading">
			<h1><img src="view/image/tawky.png" alt="" /> <?php echo $heading_title; ?></h1>
		</div>
		<div class="content">
			<iframe
			id="tawkIframe"
			src=""
			style="min-height: 300px; width : 100%; border: none">
			</iframe>
		</div>
	</div>
</div>

<script>

var currentHost = window.location.protocol + '//' + window.location.host,
	url = '<?php echo $iframe_url ?>&parentDomain=' + currentHost,
	baseUrl = '<?php echo $base_url ?>',
	storeHierarchy = <?php echo json_encode($hierarchy) ?>;

	jQuery('#tawkIframe').attr('src', url);

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
		}
	});

	function setTawkWidget(e) {
		jQuery.post('<?php echo $set_widget_url ?>', {
			pageId   : e.data.pageId,
			widgetId : e.data.widgetId,
			id       : e.data.id
		}, function(r) {
			if(r.success) {
				e.source.postMessage({action: 'setDone'}, baseUrl);
			} else {
				e.source.postMessage({action: 'setFail'}, baseUrl);
			}
		});
	}

	function removeTawkWidget(e) {
		jQuery.post('<?php echo $remove_widget_url ?>', {
			id : e.data.id
		}, function(r) {
			if(r.success) {
				e.source.postMessage({action: 'removeDone'}, baseUrl);
			} else {
				e.source.postMessage({action: 'removeFail'}, baseUrl);
			}

		});
	}
</script>

<?php echo $footer; ?>