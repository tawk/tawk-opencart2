<?php
/**
 * @package tawk.to Integration
 * @author tawk.to
 * @copyright (C) 2021 tawk.to
 * @license GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */
?><!--Start of tawk.to Script-->
<script type="text/javascript">
var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
<?php if (!is_array($customer) && $customer->isLogged() && $enable_visitor_recognition) { ?>
    Tawk_API.visitor = {
        name  : "<?php echo $customer->getFirstName(), ' ' ,$customer->getLastName(); ?>",
        email : "<?php echo $customer->getEmail(); ?>",
    };
<?php } ?>

Tawk_API.onLoad = function(){
    <?php if ($can_monitor_customer_cart) : ?>
        jQuery(document).ajaxSuccess(function (e, xhr, settings) {
            if (!settings || settings.type !== 'POST') {
                return;
            }

            if (!xhr || !xhr.responseJSON) {
                return;
            }

            var jsonData = xhr.responseJSON;
            if (!jsonData.total) {
                return;
            }

            var settingsUrl = settings.url;
            if (!settingsUrl) {
                return;
            }

            var urlParts = settingsUrl.split('?');
            if (urlParts.length === 0 || !urlParts[1]) {
                return;
            }

            var settingsUrlParams = new URLSearchParams(urlParts[1]);
            if (!settingsUrlParams.has('route')) {
                return;
            }

            var routeParam = settingsUrlParams.get('route');
            if (routeParam !== 'checkout/cart/add') {
                return;
            }

            var settingsData = new URLSearchParams(settings.data);
            if (!settingsData.has('quantity')) {
                return;
            }
            var itemQty = settingsData.get('quantity');

            var successMsgHTML = jQuery.parseHTML(jsonData.success);
            var productAnchor = jQuery(successMsgHTML).siblings('a[href*="product/product"]');
            if (productAnchor.length === 0) {
                return;
            }

            var productName = productAnchor.prop('outerText');
            var productUrl = productAnchor.prop('href');
            if (!productName || !productUrl) {
                return;
            }

            var addedItem = {
                'product-name' : productName,
                'product-url': productUrl,
                'item-qty' : itemQty,
                'cart-total' : jsonData.total,
            };

            Tawk_API.addEvent('cart-item-added', addedItem, function (error) {
                if (error) {
                    console.error(error);
                }
            });
        });
    <?php endif; ?>
};
(function(){
var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;
s1.src='https://embed.tawk.to/<?php echo $page_id ?>/<?php echo $widget_id ?>';
s1.charset='UTF-8';
s1.setAttribute('crossorigin','*');
s0.parentNode.insertBefore(s1,s0);
})();
</script>
<!--End of tawk.to Script-->
