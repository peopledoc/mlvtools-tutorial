# External.js
By: Cal Evans <cal@calevans.com>

(c) 2015 [Evans Internet Construction Company, Inc.](http://eicc.com)

License: MIT

## IMPORTANT NOTE ##
This project serves a very specific purpose and as such I don't usually take PRs or respond to requests for new features. You are welcome to fok it and make it your own. 

You can also check out [this version](https://github.com/janschoepke/reveal_external) whcich does seem to be mantained and the author seems to be open to PRs and responding to issues.

## Readme.md ##
This is a plugin for Reveal.js. It allows you to specifiy external files to be loaded into a presentation. I developed it for [Zend](http://zend.com) Training. It allows a course, which may be hundreds of slides, to be broken into modules and managed individually. This allows for a course Subject Matter Expert to be working on one module, while the designer is working on another. 

# Using external.js
Using the plugin is easy. First, register it in your Reveal.initalize block.

    { src: 'plugin/external/external.js', condition: function() { return !!document.querySelector( '[data-external]' ); } },

Then simply add an element into your presentation with a data-external attribute.

	<section data-external="module_01/index.html"> </section>

In my example, I load in all sections, so my main presentation looks like this.

	<div class="reveal">
		<!-- Any section element inside of this container is displayed as a slide -->

		<div class="slides">
			 <section data-external="module_01/index.html"> </section>
			 <section data-external="module_02/index.html"> </section>
		</div> <!-- slides -->

	</div> <!-- Reveal -->

A sample of one of the files would look like this:

	<section>
		<h2>This is a slide</h2>
		<ul>
			<li>Point 1</li>
			<li>Point 2</li>
			<li>Point 3</li>
		</ul>

		<aside class="notes">
			These are speaker notes
		</aside>
	<section>

	<section>
		<h2>This is a second slide</h2>
		<p>Just to show that you can load multiple slides at a time, this is a second slide.</p>
	</section>

This makes each include file its own sub-module that can be navigated
by the up and down cursor keys as well as the space bar,  but modules can be switched by using
left and right.

You can of course do it differently. You can also still do sub sections for slides within a separate file. Anything that can normally be done in reveal.js, can be done inside of an externally loaded file.

# Version
- 1.0.0 Initial Release

# Mantainer
[Cal Evans](https://blog.calevans.com) <cal@calevans.com>
