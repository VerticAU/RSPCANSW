({
	handleInit: function (component) {

		component.utils.callApex(
			component.get('c.getBadges'),
			{
				recordId: component.get('v.recordId')
			},
			function (responseJSON) {
				var response = JSON.parse(responseJSON);
				console.log('badgesVM', response);
				component.set('v.badgesVM', response);
			}
		)

	}
})