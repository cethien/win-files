const { addDynamicIconSelectors } = require('@iconify/tailwind');

/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./web/templates/**/*.html'],
	darkMode: 'class',
	theme: {
		extend: {}
	},
	plugins: [
		addDynamicIconSelectors(),
		function ({ addVariant }) {
			addVariant('child', '& > *');
			addVariant('child-hover', '& > *:hover');
		}
	]
};
