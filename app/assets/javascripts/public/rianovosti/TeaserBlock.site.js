(function (pluginName){
    if (typeof adriver === 'undefined') {
      return;
    }
	new adriver.Plugin(pluginName);

	new adriver.Plugin.require('functions.adriver').onLoadComplete(function(){
		adriver.prototype.TeaserBlock = {
			draw: function(a, width, height){
			if(a.reply.auditPixel){
				var ar_pix = a.checkRnd(a.checkHttp(a.reply.auditPixel));
				if (location.href.indexOf('mngcgi')==-1&&ar_pix) {
						if(document.createElement){
						var i=document.createElement('img');
						i.style.position='absolute';i.style.width=i.style.height='0px';
						i.src=ar_pix;
						a.p.appendChild(i);
						}
						else{new Image().src = ar_pix}
				}
			}
				var ar_img = a.checkRnd(a.checkHttp(a.reply.comp0)),
					sep = '|',
					alt = this.decode(a.reply.alt).split(sep),
					title = (alt[0] || ''),
                    desc = (alt[1] || '');

				if(desc){
				a.p.innerHTML = '<a href="' + a.reply.cgihref + '" target="' + a.reply.target + '" title="' + alt + '"><img src="' + ar_img + '" width="' + a.normalize(width) + '" height="' + a.normalize(height) + '" alt="' + alt + '">' + '<h1>' + title + '</h1><p>' + desc + '</p></a>';}
				else{
				a.p.innerHTML = '<a href="' + a.reply.cgihref + '" target="' + a.reply.target + '" title="' + alt + '"><img src="' + ar_img + '" width="' + a.normalize(width) + '" height="' + a.normalize(height) + '" alt="' + alt + '">' + '<p>' + title + '</p></a>';}
				return a;
			},

			decode: function(s){
				return s.replace(/&#x(.+?);/ig, function(s, v){return String.fromCharCode('0x' + v)});
			}
		}

		adriver.TeaserBlock = {
			drawContainer: function(id, width, height){
				var container = document.getElementById(id),
					items = container.getElementsByTagName('td'),
					count = items.length;
				for (var i = 0; i < count; i++){
					var a = adriver(items[i].id);
					if (a && a.reply) a.TeaserBlock.draw(a, width, height);
				}

				return container
			}
		}

		adriver.Plugin(pluginName).loadComplete();
	});
})('TeaserBlock.site');
