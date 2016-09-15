---
layout: post
title: 'Onion Routes, TLS/SSL, and Tor'
date: 2016-08-31 16:30:23
categories: post
---


<p>The concept of onion routing dates back to at least 1996, when Naval Laboratory researchers published “<a href="http://www.onion-router.net/Publications/IH-1996.pdf">Hiding Routing Information</a>“, describing an networking architecture that would be resistant to traffic analysis.</p>
<p>The basic concept was that every hop&nbsp;in the “communication chain” only knows enough information to pass information to the next stop. While all the same information would have to be accessible at some point, by dispersing that information and only letting each node get a small piece of the puzzle, only immensely&nbsp;sophisticated traffic analysis could reveal the two points of communication. Even in that instance, it would necessitate knowing each node being used and the sequence they would be used in, which is impractical. Furthermore, at each node information could be padded, delayed, and reordered to frustrate active attempts to analyze the traffic. The metaphor of “Onion Routing” is a reference to the data structure, which was intended to be several layers of encryption that surround the payload in transit.</p>
<p>At time of publication this had already been implemented for HTTP, there was a similar infrastructure implemented for telnet, and FTP/SMTP versions were being developed.</p>
<p>Attempts to anonymize Internet traffic have faced much frustration because the fundamental concept of HTTP, for example, has always been an individual locating a resource, making a request, then receiving the resource (perhaps contingent on validations). &nbsp;To locate the resource there must be some kind of universal and basically static address for that resource. For the end user to receive that resource, they must have some kind of unique and reliable identifier that allows them to be found.</p>
<p>Onion routing can work many ways, but it always necessitates control over the information that is passed from one node to another in the communication chain network. This means that a significant physical infrastructure must exist to create these chains in the first place.</p>
<p>The Tor Project has attempted to solve this problem by having volunteers run nodes and accepting donations to acquire&nbsp;their own. Proxychains has the flexibility to make this work a variety of ways, often being a mixture of the Tor infrastructure and paid socks proxies.</p>
<p>This infrastructure is the most intense strain on the network. Granted this physical infrastructure, Tor&nbsp;functions as an overlay network, meaning that it lays entirely on top of existing networking protocols and practices. It’s only innovation is to use&nbsp;these&nbsp;as a foundation, which can be recombined&nbsp;in particular ways to provide an anonymized communications.</p>
<p>For this reason Tor&nbsp;doesn’t require special privileges of any kind. It connects to particular locations in particular ways. This allows Tor&nbsp;to function on devices that user’s don’t have special privileges on.</p>
<p>The unique element of Tor&nbsp;is in the specific routes that it pushes traffic through. It has special routers, called Onion Routers, that are only different from normal in the standards their connections are held to.</p>
<p>The flow of Tor (and HTTPS) have been mapped out by the EFF:</p>
<p><a href="https://www.eff.org/pages/tor-and-https" rel="nofollow">https://www.eff.org/pages/tor-and-https</a></p>
<p>The main thing to notice from the linked diagram is that the requests do have to be decrypted/exposed at certain points to reach their destination reliably. There is an attempt to divide the information up in such a way that the user and their request are never identified simultaneously, but much can be inferred from data and targeted traffic sniffing still poses risks.</p>
<p>Imagery aside, how do these routes actually work? The are a few basic components and processes that modify the original request and create something less easily observable. Also, the main process of anonymization is carried out by encryption, though the Tor Project has emphasized that anonymization is not encryption.</p>
<ul>
<li>Connect over TLS with ephemeral keys
<ul>
<li>TLS/SSL certifies the node being used</li>
<li>TLS/SSL encrypts the information in transit</li>
</ul>
</li>
<li>Connect via Onion Proxy, which lets onion routers communicate with each other</li>
<li>Information is sent in 512 byte units&nbsp;called cells (padded if necessary) encoded with 128-bit AES cipher
<ul>
<li>Relay cells
<ul>
<li>Facilitate transfer of cells</li>
<li>Provide a streamID that keeps multiple transfers on the same circuit unique</li>
<li>Teardown broken streams if detected</li>
<li>Truncate parts of stream that have been broken
<ul>
<li>Doesn’t signal to other&nbsp;circuits that there has been a rerouting</li>
</ul>
</li>
<li>(lit.) relay data</li>
<li>tend/close successful connections</li>
<li>Extends connections to the next point in route</li>
</ul>
</li>
<li>Control cells
<ul>
<li>creates new circuit paths</li>
<li>destroys circuit paths</li>
<li>handles TCP header padding (32-bit boundary)</li>
</ul>
</li>
</ul>
</li>
<li>Circuits are established and shared amongst users
<ul>
<li>several TCP streams go through a single circuit</li>
<li>streams are kept unique by symmetric encryption and public-private key negotiation
<ul>
<li>
<p id="firstHeading" class="firstHeading" lang="en">Diffie–Hellman key exchange standard (public means of negotiating private keys)</p>
</li>
<li>In the original 1996 publication they used RSA, which is the current standard, which was used to encrypt a private key</li>
</ul>
</li>
</ul>
</li>
</ul>
<p>&nbsp;</p>
<p>The original idea of Onion routing was for anonymous communications, not necessarily anonymous browsing. The most protection of onion routing assumes that both parties are locally connected to the same network.&nbsp;Several complications arose from trying to&nbsp;apply these methods to all http requests, which would most often include servers that have no direct connection to the network and cannot decrypt requests locally. This meant that messages have to be decrypted before they reach the server and converted back into a universally coherent http request, introducing risks of deanonymization by examining the data transfers.</p>
<p>The basic flow of this is that by encrypting and decrypting http requests progressively, the request never simultaneously reveals the identity of the user/server alongside the data they’ve sent. Whether the user/server can be identified through other aspects of the request would vary on the nature and content of the request, but there is no way to keep communications of this sort encrypted end-to-end.</p>
<p>Hidden services attempt to remedy this problem by having servers locally run Tor, connecting with the user through a special link that serves as an external rendezvous point. This also means that the user is not able to see where the server is actually located, which has recommended hidden services to less-than-legal services like the Silk Road drug trade. There are known vulnerabilities to&nbsp;hidden services, such as <a href="http://freehaven.net/anonbib/#hs-attack06">manipulating circuits to force the service through corrupted relay nodes (as a guard node) that leak ip information</a>.</p>
<p>There are also correlation attack vulnerabilities. By examining the request entering Tor relays, those exiting, and that sent back by the server it is theoretically possible to &nbsp;find the end-points of communication. This is a slightly lesser risk, as it would require one individual or organization to have control over more than one node at the same time for the user they were trying to observe, which could only happen by good luck, or they would need to have&nbsp;control over points in the network that the onion route couldn’t reach.</p>
<h3>References</h3>
<p><a href="https://www.onion-router.net/Publications.html#IH-1996" rel="nofollow">https://www.onion-router.net/Publications.html#IH-1996</a><br>
<a href="https://svn.torproject.org/svn/projects/design-paper/tor-design.html" rel="nofollow">https://svn.torproject.org/svn/projects/design-paper/tor-design.html</a><br>
<a href="https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange" rel="nofollow">https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange</a><br>
<a href="https://www.torproject.org/docs/hidden-services.html.en" rel="nofollow">https://www.torproject.org/docs/hidden-services.html.en</a><br>
<a href="https://www.torproject.org/docs/faq#EntryGuards" rel="nofollow">https://www.torproject.org/docs/faq#EntryGuards</a><br>
<a href="https://www.eff.org/pages/tor-and-https" rel="nofollow">https://www.eff.org/pages/tor-and-https</a><br>
<a href="https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO" rel="nofollow">https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO</a><br>
<a href="https://www.torproject.org/docs/faq#WhyCalledTor" rel="nofollow">https://www.torproject.org/docs/faq#WhyCalledTor</a></p>
