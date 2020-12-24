/**************************************
 ** Player.IO tools badword filter. **
 * This class helps you filter badwords from your ingame chats.
 *
 * Recommended use is putting this on the receiving end just before you print the text to the screen.
 * That way you can have a client side filter that cannot be hacked
 *
 ** Arguments
 * badwordReplacement > String > what should badwords be replaced with
 * removeBadWords > Boolean > Should badwords just be removed? (Remember to filter empty lines if you use this)
 *
 * Edit the badwords array to add or remove words.
 *
 * Copyright (C) 2012 ChrisBenjaminsen.com
 * Please keep this copyright notice if you choose to share this library.
 ***************************************/
package io.player.tools{
	public class Badwords{
		public static var removeBadWords:Boolean = false
		public static var badwordReplacement:String = "****"

		private static var badwords:Array = "ahole*,anal,anally,anus*,arse*,arss*,ashole*,asshole*,asswipe*,asslick*,*ballsdeep*,*bastard*,biatch*,bish,*bitch*,*blowjob*,*bollock*,*boner,bukkak*,butthole*,buttlick*,buttplug*,buttwipe*,carpetmunch*,chink*,chode*,choad*,clit*,*cnts*,cock*,cok,cokbite*,cokhead*,cokjock*,cokmunch*,coks,coksuck*,coksmoke*,cuck,cuckold,cum,cunnie*,cunnilingus*,cunny*,*cunt*,*dick*,dik,dike*,diks,dildo*,douche*,doosh*,dooch*,*dumbars*,*dumars*,*dumass*,edjaculat*,ejacculat*,ejackulat*,ejaculat*,ejaculit*,ejakulat*,enema*,faeces*,fag*,fap,fapping*,*fatars*,*fatass*,fck*,*fcuk*,feces*,felatio*,felch*,feltch*,flikker*,*foreskin*,*forskin*,*fvck*,*fuck*,*fudgepack*,*fuk*,gaylord,*handjob*,hardon*,*hitler*,hoar,honkey*,*jackars*,*jackass*,*jackoff*,jap,*jerkoff*,jigaboo*,jiss*,*jizz*,kike*,knobjock*,knobrid*,knobsuck*,kooch*,kootch*,kraut*,kunt*,kyke*,*lardars*,*lardass*,lesbo*,lessie*,lezzie*,lezzy*,*masturbat*,minge*,minging*,mofo,muffdive*,munge*,munging*,*nazi*,*negro*,niga,nigg*,niglet*,niqqa,nutsack*,*orgasm*,*orgasum*,panooch,pecker,peanis,peeenis,peeenus,peeenusss,peenis,peenus,peinus,penas,*penis*,penor,penus,phuc,phuck*,phuk*,pissflap,poon,poonani,poonanni,poonanny,poonany,poontang,porn*,pula,pule,punani,punanni,punanny,punany,pusse,pussee,pussie,pussies,pussy,pussying,pussylick*,pussysuck*,poossy*,poossie*,puuke,puuker,queef*,queer*,qweer*,qweir*,recktum*,rectum*,renob,retard*,rimming*,rimjob*,ruski*,sadist*,scank*,schlong*,schmuck*,scrote*,scrotum*,semen*,sex*,shag,shat,shemale*,*shit*,skank*,*slut*,spic,spick,spik,stalin,tard,teets,testic*,tit,tits,titt,titty*,tittie*,twat*,*vagina*,*vaginna*,*vaggina*,*vaagina*,*vagiina*,vag,vags,vaj,vajs,*vajina*,*vulva*,wank*,*whoar*,whoe,*whor*,*B=D*,*B==D*,*B===*,*===D,8===*".toLowerCase().split(",")
		public static function Filter(original:String, forceFilter:Boolean = false):String {
			if (!Global.base.settings.wordFilter && !forceFilter) return original;
			if (original == null) return original;
			
			var torep:String = original
				
			//Remove double spaces
			torep = torep.replace(/(\s){2,}/mgi," ");
			
			// Replace fake '¡'
			torep = torep.replace("¡", "i");
				
		    //Explode word
			var exp:Array = torep.split(" ");
			
			//Concat spaced badwords like f u c k or d i c k
			var lastFound:Boolean = false;
			for( var l:int=0;l<exp.length-1;l++){
				if(
					(exp[l].length == 1 || lastFound) &&
					exp[l+1].length == 1
				){
					exp[l] += exp[l+1]
					exp.splice(l+1,1);
					l--
					lastFound = true;
					continue;
				}
				lastFound = false;
			}
			
			//Concat spaced letters;
			var found:Boolean = false;
			for( var a:int=0;a<exp.length;a++){
				if(isBadword(exp[a])){
					
					if(removeBadWords){
						exp.splice(a--,1)
					}else{
						exp[a] = badwordReplacement
					}
					found = true;
				}
			}
			
			if(found){
				return exp.join(" ");
			}
			return original;
		}
		
		public static function isBadword(word:String, inner:Boolean = false):Boolean{
			//No cheating with casing!
			word = word.toLowerCase();
			for( var a:int=0;a<badwords.length;a++){
				var badword:String = badwords[a];
				if(badword.charAt(badword.length-1) == "*" && badword.charAt(0) == "*"){
					badword = badword.substr(1).substr(0,badword.length-2);
					if(word.indexOf(badword) != -1) return true
				}else if(badword.charAt(0) == "*"){
					badword = badword.substr(1);
					if(word.length >= badword.length && word.indexOf(badword) == word.length-badword.length) return true;
				}else if(badword.charAt(0) == "+"){
					badword = badword.substr(1);
					if(word.length > badword.length && word.indexOf(badword) == word.length-badword.length) return true;
				}else if(badword.charAt(badword.length-1) == "*"){
					badword = badword.substr(0,badword.length-1);
					if(word.indexOf(badword) == 0) return true
				}else if(word.length >= badword.length && badword.charAt(badword.length-1) == "+"){
					badword = badword.substr(0,badword.length-1);
					if(word.length > badword.length && word.indexOf(badword) == 0) return true
				}else if(word == badword) return true
			}
			
			
			//Not a bad word
			if(inner) return false
				
			/*** More word processing ***/
			var processed:String;
			
			//Removing special chars
			if(isBadword(word.replace(/[^\w| ]/mgi,""),true)) return true;
			
			//Treating special chars as spaces;
			processed = word.replace(/[^\w| ]/mgi," ")
			if(processed != word && Filter(processed) != processed) return true;
			
			//Treating numbers and other chars as letters;
			processed = word;
			processed = processed.replace(/\$/mgi,"s")
			processed = processed.replace(/5/mgi, "s")
			processed = processed.replace(/3/mgi, "b")
			processed = processed.replace(/\!/mgi,"l")
			processed = processed.replace(/0/mgi, "o")
			processed = processed.replace(/1/mgi, "i")
			processed = processed.replace(/\#/mgi,"h")
			processed = processed.replace(/€/mgi, "e")
			processed = processed.replace(/3/mgi, "e")
			processed = processed.replace(/£/mgi, "e")
			processed = processed.replace(/\(/mgi,"c")
			processed = processed.replace(/2/mgi, "z")
			processed = processed.replace(/z/mgi, "s")
			processed = processed.replace(/4/mgi, "a")
			processed = processed.replace(/8/mgi, "b")
			if(isBadword(processed,true)) return true;
				
			return false;
		}
	}
}