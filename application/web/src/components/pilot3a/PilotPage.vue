<template>
	<v-container>
		<v-row>
			<LeftPanel />
			<RightPanel />
		</v-row>
	</v-container>
</template>

<script>
import LeftPanel from './LeftPanel.vue';
import RightPanel from './RightPanel.vue';

export default {
	name: 'PilotPage',
	components: {
		LeftPanel,
		RightPanel,
	}
}

</script>

<style>
@media (min-width: 0px) {
	.container {
		max-width: 100% !important;
	}
}

.toggle-main,
input {
	color: #fff;
	font: 1em "Helvetica Neue", Helvetica, sans-serif;
	line-height: 1.5;
}

.toggle-main {
	background: #863b59;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 5vh;
	overflow: hidden;
}


.toggle,
.toggle:before,
.slot__label,
.curtain {
	transition-property: background-color, transform, visibility;
	transition-duration: 0.25s;
	transition-timing-function: ease-in, cubic-bezier(0.6, 0.2, 0.4, 1.5), linear;
}

.toggle:before,
.slot,
.slot__label {
	display: block;
}

.toggle:before,
.curtain {
	position: absolute;
}

.toggle:checked,
.curtain {
	background-color: rgb(98, 134, 146);
}

.toggle:focus {
	outline: transparent;
}

.toggle {
	border-radius: 0.75em;
	box-shadow: 0 0 0 0.1em inset;
	cursor: pointer;
	position: relative;
	margin-right: 0.25em;
	width: 3em;
	height: 1.5em;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	-webkit-tap-highlight-color: transparent;
}

.toggle:before {
	background: currentColor;
	border-radius: 50%;
	content: "";
	top: 0.2em;
	left: 0.2em;
	width: 1.1em;
	height: 1.1em;
}

.toggle:checked:before {
	transform: translateX(1.5em);
}

.toggle:checked~.slot .slot__label,
.slot__label:nth-child(2) {
	transform: translateY(-50%) scaleY(0);
}

.toggle:checked~.slot .slot__label:nth-child(2) {
	transform: translateY(-100%) scaleY(1);
}

.toggle:checked~.curtain {
	transform: scaleX(1);
}

.slot {
	color: transparent;
	font-size: 1.5em;
	font-weight: bold;
	letter-spacing: 0.1em;
	line-height: 1;
	overflow: hidden;
	height: 1em;
	text-indent: -0.9em;
	-webkit-text-stroke: 0.05em #fff;
}

.slot__label {
	transform-origin: 50% 0;
}

.slot__label:nth-child(2) {
	transform-origin: 50% 100%;
}

.curtain {
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	transform: scaleX(0);
	transform-origin: 0 50%;
	z-index: -1;
}
</style>
