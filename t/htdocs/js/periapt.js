
// Data structures to hold our images and other data 
var srcArray = new Array;
var hrefArray = new Array;
var heightArray = new Array;
var titleArray = new Array;
var widthArray = new Array;
var blurbArray = new Array;
var imgGroup= new YAHOO.util.ImageLoader.group('imgGroup', null, 10);

function loadImage() {
 // Populate data structures
 srcArray[0] = YAHOO.util.Dom.get('dyn2').src;
 titleArray[0] = YAHOO.util.Dom.get('dyn2').title;
 hrefArray[0] = YAHOO.util.Dom.get('dyn1').href;
 heightArray[0] = YAHOO.util.Dom.get('dyn2').height;
 widthArray[0] = YAHOO.util.Dom.get('dyn2').width;
 blurbArray[0] = YAHOO.util.Dom.get('dyn01').innerHTML;
 
 srcArray[1] = "/img/portfolio/aquabats.png";
 titleArray[1] = "aquabats social club for the blind";
 imgGroup.registerSrcImage('img1', "/img/portfolio/aquabats.png");
 hrefArray[1] = "http://www.aquabats-social.org";
 heightArray[1] = "221";
 widthArray[1] = "350";
 blurbArray[1] = '<a href="http://www.aqubats-social.org">Aquabats Sports and Social club</a> is a small, friendly charity run by and for disabled people to organize sports and social events in and around London. We run their web-site on a pro-bono basis.';
 
 srcArray[2] = "/img/portfolio/tearsofblood.png";
 titleArray[2] = "Tears of Blood ADnD hobby site";
 imgGroup.registerSrcImage('img2', "/img/portfolio/tearsofblood.png");
 hrefArray[2] = "http://www.tearsofblood.silasthemonk.org.uk";
 heightArray[2] = "345";
 widthArray[2] = "350";
 blurbArray[2] = '<a href="http://www.tearsofblood.silasthemonk.org.uk">Tears of Blood</a> is a community based Dungeons and Dragons campaign world. Its website needs a big reworking so watch this space.';
 
 srcArray[3] = "/img/portfolio/crownroast.jpg";
 titleArray[3] = "The Crown Roast Butchers";
 imgGroup.registerSrcImage('img3', "/img/portfolio/crownroast.jpg");
 hrefArray[3] = "http://www.crownroast.co.uk";
 heightArray[3] = "226";
 widthArray[3] = "345";
 blurbArray[3] = 'The <a href="http://www.crownroast.co.uk">Crown Roast</a> is Hurst Green, Oxted&rsquo;s friendly, local butcher and fruiterer.';

 srcArray[4] = "/img/portfolio/thakar.jpg";
 titleArray[4] = "Thakar Optometrists";
 imgGroup.registerSrcImage('img4', "/img/portfolio/thakar.jpg");
 hrefArray[4] = "http://www.thakaroptometrists.co.uk";
 heightArray[4] = "370";
 widthArray[4] = "345";
 blurbArray[4] = '<a href="http://www.thakaroptometrists.co.uk">Thakar Optometrists</a> have been providing eyecare to the local community for over 36 years.';

 // set timer to change the image and links every 30 secs
 setInterval('changeImage()', 30000);

}

function changeImage() {
 var randomindex=Math.floor(Math.random()*5);
 YAHOO.util.Dom.get('dyn2').alt = hrefArray[randomindex];
 YAHOO.util.Dom.get('dyn1').href = hrefArray[randomindex];
 YAHOO.util.Dom.get('dyn2').title = titleArray[randomindex];
 YAHOO.util.Dom.get('dyn2').src = srcArray[randomindex];
 YAHOO.util.Dom.get('dyn2').height = heightArray[randomindex];
 YAHOO.util.Dom.get('dyn2').width = widthArray[randomindex];
 YAHOO.util.Dom.get('dyn01').innerHTML = blurbArray[randomindex];
 
 sizeAmulets();
}

YAHOO.util.Event.onDOMReady(loadImage);
