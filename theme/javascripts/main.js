if(!Date.now){Date.now=function(){return new Date().getTime()}}if(window.sessionStorage){var lastVisit=parseInt(window.sessionStorage.getItem("last-visit"));if(!isNaN(lastVisit)&&lastVisit>0){var now=Date.now()/1000|0;if(now-lastVisit>60*60*24){window.sessionStorage.clear()}}}(function($,global){function bindFlowers(){$(".flower").click(onFlowerClick).each(function(){var $this=$(this);if(window.sessionStorage){var visited=window.sessionStorage.getItem($this.attr("id"));if(visited){$this.addClass("visited")}}})}function onFlowerClick(){var $this=$(this);$this.addClass("visited");if(window.sessionStorage){window.sessionStorage.setItem($this.attr("id"),"visited");window.sessionStorage.setItem("last-visit",Date.now()/1000|0)}return true}global.bindFlowers=bindFlowers})(jQuery,window);