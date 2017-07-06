<?php
/**
 * @package Tawk.to Integration
 * @author Tawk.to
 * @copyright (C) 2014- Tawk.to
 * @license GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */
?>

<!--Start of Tawk.to Script-->
<script type="text/javascript">
var Tawk_API={},$_Tawk_LoadStart=new Date();

<?php
if (!is_array($customer) && $customer->isLogged()) {
    ?>
    Tawk_API.visitor = {
        name  : "<?php echo $customer->getFirstName(), ' ' ,$customer->getLastName(); ?>",
        email : "<?php echo $customer->getEmail(); ?>",
    };
    Tawk_API.onLoad = function(){
        setTimeout(function() {
            Tawk_API.setAttributes({
                'current-page' : '<?php echo $current_page; ?>',
                'user-id'    : '<?php echo $customer->getId(); ?>',
                'address'    : '<?php echo $customer->address['address_1'].', '.$customer->address['address_2']; ?>',
                'city'    : '<?php echo $customer->address['city']; ?>',
                'postcode'    : '<?php echo $customer->address['postcode']; ?>',
                'country'    : '<?php echo $customer->address['country']['name']; ?>',
                'phone'    : '<?php echo $customer->getTelephone(); ?>',
            }, function(error){
                
            });

            <?php if (!empty($orders)) : ?>
            Tawk_API.setAttributes({
                    'last-order' : 'Order <?php echo $orders['order_id']; ?> (<?php echo $orders['date_added']; ?>)',
                    'order-total' : '<?php echo $orders['total']; ?>',
                    'order-status' : '<?php echo $orders['status']; ?>',
                    'order-href' : '<?php echo $orders['href']; ?>',
                }, function(error){
                    
                });
            <?php endif; ?>

            <?php if (!empty($cart_data)) : ?>
            Tawk_API.setAttributes({
                    'current-cart-items' : '<?php echo count($cart_data); ?>',
                    <?php foreach ($cart_data as $key => $value) : ?>
                    'item-<?php echo ($key+1); ?>' : '<?php echo $value['name']; ?>',
                    'item-<?php echo ($key+1); ?>-quantity' : '<?php echo $value['quantity']; ?>',
                    'item-<?php echo ($key+1); ?>-price' : '<?php echo $value['price']; ?>',
                    'item-<?php echo ($key+1); ?>-total' : '<?php echo $value['total']; ?>',
                    <?php endforeach; ?>
                }, function(error){
                    
                });
            <?php endif; ?>
        }, 3000);
    };
    <?php
}
?>

(function(){
var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;
s1.src='https://embed.tawk.to/<?php echo $page_id ?>/<?php echo $widget_id ?>';
s1.charset='UTF-8';
s1.setAttribute('crossorigin','*');
s0.parentNode.insertBefore(s1,s0);
})();

</script>
<!--End of Tawk.to Script-->