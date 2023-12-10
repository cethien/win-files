const { addDynamicIconSelectors } = require('@iconify/tailwind')

/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./views/**/*.{ts,css,templ}'],
	darkMode: 'class',
	theme: {
		extend: {}
	},
	plugins: [
		addDynamicIconSelectors(),
		function ({ addVariant }) {
			addVariant('child', '& > *')
			addVariant('child-hover', '& > *:hover')
		}
	]
}
