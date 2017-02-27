class SmartLockController < UIViewController

	def viewDidLoad
		super

		self.title = 'Smart Lock'
		self.view.backgroundColor = UIColor.whiteColor

		@lock_unlock_view = UIView.new

		@message_area = UILabel.new
		@message_area.backgroundColor = UIColor.lightGrayColor
		@message_area.text = "Select Function"
		@message_area.adjustsFontSizeToFitWidth = true
		@message_area.textAlignment = NSTextAlignmentCenter

		@lock = UILabel.new
		@lock.text = "Lock"
		@lock.textAlignment = NSTextAlignmentLeft

		@lock_switch = UISwitch.new
		@lock_switch.onTintColor = UIColor.colorWithRed(0.8078, green:0.2823 , blue:0.2313, alpha: 1.0)
		@lock_switch.tintColor = UIColor.colorWithRed(0.0387, green:0.7354 , blue:0.2258, alpha: 0.6)
		@lock_switch.addTarget(self, action: 'lock_unlock:', forControlEvents: UIControlEventValueChanged)

		@unlock = UILabel.new
		@unlock.text = "Unlock"
		@unlock.textAlignment = NSTextAlignmentRight

		Motion::Layout.new do |layout|
			layout.view view
			layout.subviews "message_area" => @message_area, "lock_unlock_view" => @lock_unlock_view
			layout.metrics "margin" => 10, "height" => 50
			layout.vertical "|-64-[message_area(==60)]-margin-[lock_unlock_view(==height)]-(>=20)-|"
			layout.horizontal "|-0-[message_area]-0-|"
			layout.horizontal "|-0-[lock_unlock_view]-0-|"
		end

		Motion::Layout.new do |layout|
			layout.view @lock_unlock_view
			layout.subviews "lock" => @lock, "lock_switch" => @lock_switch, "unlock" => @unlock
			layout.metrics "margin" => 10, "height" => 50
			layout.vertical "|-0-[unlock(==height)][lock_switch(==height)][lock(==height)]-0-|"
			layout.horizontal "|-0-[unlock(<=140)]-20-[lock_switch]-5-[lock(<=140)]-0-|"
		end

		@lock = nil
		@unlock = nil
	end

	def hideNotificationTimer
		UIView.animateWithDuration(1, delay:0.0, options: UIViewAnimationOptionCurveEaseIn, animations: lambda{
      @message_area.frame  = [[0, 4], [self.view.frame.size.width,60]]
	    }, completion: lambda { |finsihed|
	    	UIView.animateWithDuration(1, delay:0.0, options: UIViewAnimationOptionCurveEaseIn, animations: lambda{
		    	@message_area.backgroundColor = UIColor.lightGrayColor
					@message_area.text = "Select Function"
					@message_area.frame  = [[0, 164], [self.view.frame.size.width,60]]
				}, completion: nil);
	    })
		
	end

	def lock_unlock(value)
		if value.isOn
			@url = "http://192.168.0.181:3000/api/smart_lock/door/lock"
			alert_text = "Locking..."
		else
			@url = "http://192.168.0.181:3000/api/smart_lock/door/unlock"
			alert_text = "Unlocking..."
		end

		alert = UIAlertView.new
		alert.message = alert_text
		alert.show

		AFMotion::JSON.get(@url) do |result|
			if result.success?
				UIView.animateWithDuration(1, delay:0.0, options: UIViewAnimationOptionCurveEaseIn, animations: lambda{
					@message_area.frame  = [[0, 4], [self.view.frame.size.width,60]]
		    }, completion: lambda { |finsihed|
		    		@message_area.backgroundColor = UIColor.colorWithRed(0.0387, green:0.7354 , blue:0.2258, alpha: 0.6)
						@message_area.text = result.object['position'].capitalize
			    	UIView.animateWithDuration(1, delay:0.0, options: UIViewAnimationOptionCurveEaseIn, animations: lambda{
			      @message_area.frame  = [[0, 164], [self.view.frame.size.width,60]]
			    }, completion:nil)
		    })

				alert.dismissWithClickedButtonIndex(-1, animated: true)
			elsif result.failure?
				@message_area.backgroundColor = UIColor.redColor
				@message_area.text = result.object['position'].capitalize
				alert.dismissWithClickedButtonIndex(-1, animated: true)
			end

			timer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector:'hideNotificationTimer', userInfo:nil, repeats:false)
			timer = nil
		end
	end

end

