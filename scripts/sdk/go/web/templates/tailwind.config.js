import { addDynamicIconSelectors } from ( '@iconify/tailwind' )

/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./views/**/*.{ts,css,templ}'],
	darkMode: 'class',
	theme: {
		extend: {}
	},
	plugins: [
		addDynamicIconSelectors(),
	]
}
