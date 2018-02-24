<?php include_once('header.php');?>
<?php include_once('menu.php');?>
<div class="container mt-4 mb-4">
	<div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
		<a class="nav-link active" id="v-pills-about-tab" data-toggle="pill" href="#v-pills-about" role="tab" aria-controls="v-pills-about" aria-selected="true">About</a>
		<a class="nav-link" id="v-pills-roadmap-tab" data-toggle="pill" href="#v-pills-roadmap" role="tab" aria-controls="v-pills-roadmap" aria-selected="false">Roadmap</a>
		<a class="nav-link" id="v-pills-team-tab" data-toggle="pill" href="#v-pills-team" role="tab" aria-controls="v-pills-team" aria-selected="false">Team</a>
		<a class="nav-link" id="v-pills-faqs-tab" data-toggle="pill" href="#v-pills-faqs" role="tab" aria-controls="v-pills-faqs" aria-selected="false">FAQs</a>
	</div>
	<div class="tab-content" id="v-pills-tabContent">
		<div class="tab-pane fade show active" id="v-pills-about" role="tabpanel" aria-labelledby="v-pills-about-tab">
			<h1>About AryaLinux</h1>
		</div>
		<div class="tab-pane fade" id="v-pills-roadmap" role="tabpanel" aria-labelledby="v-pills-roadmap-tab">
			<h1>Roadmap</h1>
		</div>
		<div class="tab-pane fade" id="v-pills-team" role="tabpanel" aria-labelledby="v-pills-team-tab">
			<h1>Team AryaLinux</h1>
		</div>
		<div class="tab-pane fade" id="v-pills-faqs" role="tabpanel" aria-labelledby="v-pills-faqs-tab">
			<h1>Frequently Asked Questions</h1>
		</div>
	</div>
</div>
<?php include_once('footer.php');?>