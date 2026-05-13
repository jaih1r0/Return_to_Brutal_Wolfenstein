//
//	this is pretty much just BW_ZF_GenericMenu but inheriting from a Listmenu
//

class BW_ZF_ListMenu : listmenu {
	double dt,prevms;
	double focusedtics, openedTics;
	
	ListMenuDescriptor mDesc;
	MenuItemBase mFocusControl;
	/// The top-level frame of the menu's element tree.
	///
	/// All top-level elements should be packed into this frame.
	BW_ZF_Frame mainFrame;

	/// The default elements that are focused when the user hasn't got anything
	/// focused and presses a navigation button.
	BW_ZF_Element focusDefaults[BW_ZF_NavEventType_FocusChangeCount];

	private BW_ZF_ElementTreeGlobal globalStore;

	/// Returns where the mouse position currently is in the menu.
	Vector2 getMousePos() { return globalStore.mousePos; }

	/// Sets the currently focused element to be `elem`, as if it came from the
	/// direction `type`.
	void setFocus(BW_ZF_Element elem, BW_ZF_NavEventType type) {
		let old = globalStore.focus;
		globalStore.focus = elem;
		elem.beenFocused(type);
		changeFocusIndicator(old, globalStore.focus);
		if (globalStore.focusIndicator != NULL) globalStore.focusIndicator.show();
	}
	/// Returns the element that is drawn as an indicator of what element is
	/// focused.
	BW_ZF_Element getFocusIndicator() { return globalStore.focusIndicator; }
	/// Sets the element that is drawn as an indicator of what element is
	/// focused.
	void setFocusIndicator(BW_ZF_Element focusIndicator) { globalStore.focusIndicator = focusIndicator; }

	/// Returns the focus indicator's priority.
	///
	/// See [`ZF_FocusPriority`].
	BW_ZF_FocusPriority getFocusPriority() { return globalStore.focusPriority; }
	/// Sets the focus indicator's priority.
	///
	/// See [`ZF_FocusPriority`].
	void setFocusPriority(BW_ZF_FocusPriority focusPriority) { globalStore.focusPriority = focusPriority; }

	override void init(Menu parent, ListMenuDescriptor desc) {
		//Super.init(parent,desc);
		mDesc = desc;
		
		AnimatedTransition = mDesc.mAnimatedTransition;
		Animated = mDesc.mAnimated;
		DontBlur = mDesc.mDontBlur;
		DontDim = true; //mDesc.mDontDim;
		
		
		mParentmenu = parent;
		
		mainFrame = BW_ZF_Frame.create((0, 0), (320, 200));
		globalStore = new("BW_ZF_ElementTreeGlobal");
		mainFrame.setGlobalStore(globalStore);
		mainFrame.setBaseResolution((320, 200));
		globalStore.mainFrame = mainFrame;
		globalStore.needsMouseUpdate = true;
		setupFocusIndicator();
		if (globalStore.focusIndicator != NULL) {
			globalStore.focusIndicator.hide();
		}
		
	}

	/// Sets the resolution of the virtual ZForms screen.
	void setBaseResolution(Vector2 size) {
		mainFrame.setBox((0, 0), size);
		mainFrame.setBaseResolution(size);
	}

	/// Called whenever the back button is pressed, so that its behaviour can
	/// be overridden if needed.
	///
	/// Normally this gives all the elements in the tree a chance to override
	/// it, and if none of them did, it closes this menu.
	virtual void handleBack() {
		if (!mainFrame.handleBack()) {
			close();
			let m = GetCurrentMenu();
			MenuSound(m != null ? "menu/backup" : "menu/clear");
			if (!m) menuDelegate.MenuDismissed();
		}
	}

	override bool translateKeyboardEvents() {
		if (globalStore == NULL) return true;
		return !globalStore.blockMenuEvent;
	}

	override void ticker() {
		//Super.ticker();
		mainFrame.ticker();
	}

	override void drawer() {
		if (globalStore.focus != NULL) {
			BW_ZF_AABB box;
			globalStore.focus.getFocusAABB(box);
			positionFocusIndicator(box.pos, box.size);
		}

		if (globalStore.needsMouseUpdate) {
			let mouseBlock = mainFrame.handlePriorityMouseBlock(false, globalStore.mousePos);
			mainFrame.handleMousePosition(mouseBlock, globalStore.mousePos);
			globalStore.needsMouseUpdate = false;
		}
		mainFrame.drawer();
		mainFrame.topDrawer();
		
		
		if(!prevms)
		{
			prevms = MSTime();
			return;
		}
		double mstime = MSTime() - prevms;
		prevms = MSTime();
		double deltatime = 1000.0 / 60.0;
		dt = (max(1,mstime)/deltatime);
		
		if(getfocus() != null)
			focusedTics += dt;
		else
			focusedTics = 0;
		
		openedTics += dt;
		
	}

	/// Called when the menu wants a focus indicator to be set up.
	///
	/// # Examples
	///
	/// ```
	/// override void setupFocusIndicator() {
	///     let focusBox = ZF_BoxTextures.CreateTexturePixels (
	///         "Graphics/FocusIndicator.png",
	///         (16, 16),
	///         (16, 16),
	///         true,
	///         true
	///     );
	///
	///     setFocusIndicator(ZF_BoxImage.create((0, 0), (0, 0), focusBox));
	///     setFocusPriority(ZF_FocusPriority_JustAboveFocused);
	/// }
	/// ```
	virtual void setupFocusIndicator() {}
	/// Called when the menu wants the focus indicator to be moved to a new element.
	/// 
	/// This should not position the indicator - see [`positionFocusIndicator`].
	virtual void changeFocusIndicator(BW_ZF_Element oldFocus, BW_ZF_Element newFocus) {}
	/// Called when the focus indicator should change position or size.
	///
	/// # Examples
	///
	/// ```
	/// override void positionFocusIndicator(Vector2 pos, Vector2 size) {
	///     getFocusIndicator().setBox(pos, size);
	/// }
	/// ```
	virtual void positionFocusIndicator(Vector2 pos, Vector2 size) {}

	private void fireNavigationEvent(BW_ZF_NavEventType type, bool fromController) {
		if (type == BW_ZF_NavEventType_Deny) {
			handleBack();
		}

		if (mainFrame.onNavEvent(type, fromController)) return;

		if (type < BW_ZF_NavEventType_FocusChangeCount) {
			BW_ZF_Element newFocus;
			if (globalStore.focus == NULL) {
				newFocus = focusDefaults[type];
			} else {
				newFocus = globalStore.focus.getFocusNeighbor(type);
			}
			if (newFocus != NULL) {
				
				let oldFocus = globalStore.focus;
				setFocus(newFocus, type);
			}
		}
	}

	// "relay" all UI events down to the elements so they can handle them
	override bool onUIEvent(UIEvent ev) {
		if (ev.type == UIEvent.Type_KeyDown && (ev.keyChar == UIEvent.Key_Escape || ev.keyChar == UIEvent.Key_Back)) {
			handleBack();
		}
		if (ev.type == UIEvent.Type_MouseMove) {
			globalStore.mousePos.x = ev.mouseX;
			globalStore.mousePos.y = ev.mouseY;
			globalStore.needsMouseUpdate = true;
			return true;
		}
		if (ev.type == UIEvent.Type_LButtonDown) {
			let oldFocus = globalStore.focus;
			globalStore.focus = NULL;
			changeFocusIndicator(oldFocus, NULL);
			if (globalStore.focusIndicator != NULL) globalStore.focusIndicator.hide();
			SetCapture(true);
		}
		if (ev.type == UIEvent.Type_LButtonUp) {
			SetCapture(false);
		}

		BW_ZF_UiEvent zfEv;

		BW_ZF_UiEvent.fromGZDUiEvent(ev, zfEv);
		if (mainFrame.onUIEventPriority(zfEv)) return true;
		if (mainFrame.onUIEvent(zfEv)) return true;

		return true;
	}

	override bool menuEvent(int mkey, bool fromcontroller) {
		if (globalStore != NULL && globalStore.blockMenuEvent) return true;

		switch (mkey) {
		case MKEY_Up:    fireNavigationEvent(BW_ZF_NavEventType_Up, fromcontroller); break;
		case MKEY_Down:  fireNavigationEvent(BW_ZF_NavEventType_Down, fromcontroller); break;
		case MKEY_Left:  fireNavigationEvent(BW_ZF_NavEventType_Left, fromcontroller); break;
		case MKEY_Right: fireNavigationEvent(BW_ZF_NavEventType_Right, fromcontroller); break;

		case MKEY_PageUp:   fireNavigationEvent(BW_ZF_NavEventType_PageUp, fromcontroller); break;
		case MKEY_PageDown: fireNavigationEvent(BW_ZF_NavEventType_PageDown, fromcontroller); break;

		case MKEY_Enter: fireNavigationEvent(BW_ZF_NavEventType_Confirm, fromcontroller); break;
		case MKEY_Back:  fireNavigationEvent(BW_ZF_NavEventType_Deny, fromcontroller); break;
		}
		return true;
	}
	
	
	BW_ZF_Element getFocus()
	{
		return globalStore.focus;
	}
}




//	the focus indicator element, in this case 2 half boxes that moves from opposite directions
class BWFocuser : BW_ZF_Element
{
	double prog;
	private BW_ZF_BoxTextures textures[2];
	private BW_ZF_BoxDrawer boxDrawer;
	
	static BWFocuser Create(vector2 pos, vector2 size, BW_ZF_BoxTextures tex1, BW_ZF_BoxTextures tex2)
	{
		let ret = new("BWFocuser");
		ret.setbox(pos,size);
		ret.textures[0] = tex1;
		ret.textures[1] = tex2;
		ret.setAlpha(1.0);
		return ret;
	}
	
	const animSep = 10;
	
	override void drawer() {
		if (hidden) { return; }
		
		BW_ZF_AABB beforeClip, clipRect;
		screenClip(beforeClip, clipRect);
		
		double sep = animSep * 2;
		
		Screen.setClipRect(int(clipRect.pos.x - sep), int(clipRect.pos.y), int(clipRect.size.x + sep * 2), int(clipRect.size.y));
		
		boxDrawer.draw(self, ((1 - prog) * animSep, 0), box.size , textures[0], true, (1,1));
		boxDrawer.draw(self, ((1 - prog) * -animSep, 0), box.size , textures[1], true, (1,1));

		Screen.setClipRect(int(beforeClip.pos.x), int(beforeClip.pos.y), int(beforeClip.size.x), int(beforeClip.size.y));
	}
}


/*
//
//	this thing was just a rotated label, to emulate minecraft splash texts, but doesnt look too good here
//

class BW_ZF_SplashLabel : BW_ZF_Element {
	private void config(
		string text = "", Font fnt = NULL, AlignType alignment = AlignType_TopLeft, bool wrap = true,
		bool autoSize = false, double textScale = 1, int textColor = Font.CR_WHITE, double lineSpacing = 0,
		BW_ZF_Element forElement = NULL
	) {
		calculate = false;
		setFont(fnt);
		setText(text);
		setAlignment(alignment);
		setWrap(wrap);
		setAutoSize(autoSize);
		setTextScale(textScale);
		setTextColor(textColor);
		setAlpha(1.0);
		setLineSpacing(lineSpacing);
		setForElement(forElement);
		calculate = true;

		recalculateLines();
	}

	/// Returns a newly created label element.
	///
	/// The position used is relative to whatever the element is packed into later. The element's
	/// text is aligned to `alignment`, and if `autoSize` is set to `true`, the element changes its
	/// own size to fit the text. The text is drawn with `lineSpacing` pixels of spacing between
	/// lines.
	///
	/// `textColor` takes on values from [`Font.EColorRange`], which cannot be named as a type due
	/// to current ZScript limitations.
	///
	/// If `fnt` is `NULL`, then `smallfont` is used instead.
	///
	/// If `forElement` is not `NULL`, clicking on the returned label will call
	/// [`ZF_Element.activate`] on `forElement`.
	static BW_ZF_SplashLabel create(
		Vector2 pos, Vector2 size, string text = "", Font fnt = NULL, AlignType alignment = AlignType_TopLeft,
		bool wrap = true, bool autoSize = false, double textScale = 1, int textColor = Font.CR_WHITE,
		double lineSpacing = 0, BW_ZF_Element forElement = NULL
	) {
		let ret = new('BW_ZF_SplashLabel');

		ret.setBox(pos, size);
		ret.config(text, fnt, alignment, wrap, autoSize, textScale, textColor, lineSpacing, forElement);
		ret.stf = new("Shape2DTransform");
		ret.stf.translate((0,size.y));
		ret.stf.rotate(-6);
		return ret;
	}

	private Font fnt;
	/// Returns the font this label will use for drawing.
	Font getFont() { return fnt; }
	/// Sets the font this label will use for drawing.
	///
	/// If this is `NULL`, then `smallfont` is used instead.
	void setFont(Font fnt) {
		if (fnt == NULL) {
			self.fnt = smallfont;
		}
		else {
			self.fnt = fnt;
		}
		recalculateLines();
	}

	private string text;
	/// Returns the text that will be drawn to the screen.
	string getText() { return self.text; }
	/// Sets the text that will be drawn to the screen.
	void setText(string text) { self.text = text; recalculateLines(); }

	private double textScale;
	/// Returns the scaling factor for the drawn text.
	double getTextScale() { return self.textScale; }
	/// Sets the scaling factor for the drawn text.
	void setTextScale(double textScale) { self.textScale = textScale; recalculateLines(); }

	private AlignType alignment;
	/// Returns the alignment that will be used for drawing the text.
	AlignType getAlignment() { return self.alignment; }
	/// Sets the alignment that will be used for drawing the text.
	void setAlignment(AlignType alignment) { self.alignment = alignment; }

	private int textColor;
	/// Returns the text color.
	///
	/// This is really a [`Font.EColorRange`], but ZScript currently is a bit limited here.
	int getTextColor() { return self.textColor; }
	/// Sets the text color.
	///
	/// This is really a [`Font.EColorRange`], but ZScript currently is a bit limited here.
	void setTextColor(int textColor) { self.textColor = textColor; }

	private bool wrap;
	/// Returns `true` if the text wraps, `false` if it overflows.
	bool getWrap() { return self.wrap; }
	/// Sets whether the text wraps or overflows.
	void setWrap(bool wrap) { self.wrap = wrap; recalculateLines(); }

	private bool autoSize;
	/// Returns `true` if the label changes its size to match the text, `false` if it doesn't.
	bool getAutoSize() { return self.autoSize; }
	/// Sets whether the label changes its size to match the text.
	void setAutoSize(bool autoSize) { self.autoSize = autoSize; }

	private double lineSpacing;
	/// Returns the amount of pixels between lines in the label.
	double getLineSpacing() { return self.lineSpacing; }
	/// Sets the amount of pixels between lines in the label.
	void setLineSpacing(double lineSpacing) { self.lineSpacing = lineSpacing; }

	private BW_ZF_Element forElement;
	/// Returns the element that will be sent `activate` function calls if this element is clicked.
	///
	/// A `NULL` return means no element will receive these calls from this label.
	BW_ZF_Element getForElement() { return self.forElement; }
	/// Sets the element that will be sent `activate` function calls if this element is clicked.
	///
	/// A `NULL` argument means that no element will receive these calls from this label.
	void setForElement(BW_ZF_Element forElement) { self.forElement = forElement; }

	private bool clicking;

	private BrokenLines lines;
	private bool calculate;
	private void recalculateLines() {
		if (calculate && wrap) {
			lines = fnt.breakLines(text, int(box.size.x / textScale));
		}
	}

	override void onBoxChanged() {
		recalculateLines();
	}

	override void ticker() {
		if (autoSize) {
			if (wrap) {
				int fntHeight = fnt.getHeight();
				box.size.y = fntHeight * textScale * lines.count();
			}
			else {
				Array<string> split;
				text.split(split, "\n");
				int fntHeight = fnt.getHeight();
				box.size.y = fntHeight * split.size() * textScale;
				box.size.x = fnt.stringWidth(text) * textScale;
			}
		}
	}
	
	shape2dtransform stf;
	
	override void drawer() {
		screen.settransform(stf);
		BW_ZF_AABB beforeClip, clipRect;
		screenClip(beforeClip, clipRect);
		//Screen.setClipRect(int(clipRect.pos.x), int(clipRect.pos.y), int(clipRect.size.x), int(clipRect.size.y));
		
		if (!wrap) {
			Array<string> split;
			text.split(split, "\n");
			Vector2 pos = getAlignedDrawPos(box.size, (fnt.stringWidth(text), split.size() * fnt.getHeight()) * textScale, alignment);
			drawText(pos, fnt, text, textColor, textScale);
		}
		else {
			int fntHeight = fnt.getHeight();
			float lineHeight = fntHeight + lineSpacing;

			Vector2 pos = getAlignedDrawPos(
				box.size,
				(0, (lineHeight * lines.count() - lineSpacing) * textScale),
				alignment
			);

			for (int i = 0; i < lines.count(); i++) {
				string line = lines.stringAt(i);
				Vector2 linePos = getAlignedDrawPos(box.size, (fnt.stringWidth(line) * textScale, 0), alignment);
				drawText((linePos.x, pos.y + (lineHeight * i * textScale)), fnt, line, textColor, textScale);
			}
		}

		//Screen.setClipRect(int(beforeClip.pos.x), int(beforeClip.pos.y), int(beforeClip.size.x), int(beforeClip.size.y));
		screen.ClearTransform();
	}

	override bool onNavEvent(BW_ZF_NavEventType type, bool fromController) {
		if (forElement == NULL) return false;

		if (isFocused() && type == BW_ZF_NavEventType_Confirm) {
			if (forElement.isEnabled()) {
				forElement.activate();
				return true;
			}
		}
		return false;
	}

	override bool onUIEvent(BW_ZF_UiEvent ev) {
		if (forElement == NULL) return false;
		if (ev.type == UIEvent.Type_LButtonDown) {
			BW_ZF_AABB screenBox; boxToScreen(screenBox);
			let mousePos = getGlobalStore().mousePos;
			if (!mouseBlock && isEnabled() && screenBox.pointCollides(mousePos)) {
				clicking = true;
				setHoverBlock(self);
			}
		}
		else if (ev.type == UIEvent.Type_LButtonUp) {
			BW_ZF_AABB screenBox; boxToScreen(screenBox);
			let mousePos = getGlobalStore().mousePos;
			if (isEnabled() && screenBox.pointCollides(mousePos) && clicking) {
				if (forElement.isEnabled()) forElement.activate();
				clicking = false;
				setHoverBlock(NULL);
			}
		}
		return false;
	}
}
*/