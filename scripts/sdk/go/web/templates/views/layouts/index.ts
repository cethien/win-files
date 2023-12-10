import * as htmx from 'htmx.org'

import persist from '@alpinejs/persist'
import Alpine from 'alpinejs'

declare global {
	interface Window {
		htmx: typeof htmx
		Alpine: typeof Alpine
	}
}

window.htmx = htmx || {}
window.Alpine = Alpine || {}

Alpine.plugin(persist)
Alpine.start()
