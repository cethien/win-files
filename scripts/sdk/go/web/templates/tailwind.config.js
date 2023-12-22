const { addDynamicIconSelectors } = require('@iconify/tailwind')

/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./views/**/*.{ts,css,templ}'],
	darkMode: 'class',
	plugins: [addDynamicIconSelectors()]
}
