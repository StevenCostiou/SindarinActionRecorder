Class {
	#name : 'StSindarinDebuggerActionRecorderPresenter',
	#superclass : 'SpPresenter',
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'toolbar',
		'registry',
		'table',
		'events',
		'code'
	],
	#category : 'NewTools-Sindarin-ActionRecorder',
	#package : 'NewTools-Sindarin-ActionRecorder'
}

{ #category : 'debugger extension' }
StSindarinDebuggerActionRecorderPresenter >> debuggerExtensionToolName [
	^'Debugging actions recorder'
]

{ #category : 'layout' }
StSindarinDebuggerActionRecorderPresenter >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		  add: (SpBoxLayout newTopToBottom
				   add: #toolbar expand: false;
				   add: #registry;
				   yourself);
		  add: #code;
		  yourself
]

{ #category : 'accessing' }
StSindarinDebuggerActionRecorderPresenter >> events [

	^ events ifNil: [ events := OrderedCollection new ]
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> initialize [

	super initialize.
	self subscribeToActionModel
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> initializePresenters [

	registry := SpColumnViewPresenter new.

	registry addColumn: (SpColumnViewColumn new
			 title: 'Action';
			 setup: [ :aPresenter |
				 | presenter |
				 (presenter := aPresenter newPresenter)
					 layout: (SpBoxLayout newHorizontal
							  spacing: 5;
							  add: presenter newLabel expand: false;
							  add: presenter newLabel;
							  add: presenter newLabel;
							  yourself);
					 yourself ];
			 bind: [ :aPresenter :event |
				 | index action node |
				 index := aPresenter layout children first.
				 index label: (events indexOf: event) printString.
				 action := aPresenter layout children second.
				 action label:
					 (String streamContents: [ :str | event printOn: str ]).
				 node := aPresenter layout children third.
				 node label: event node printString ];
			 yourself).
	registry addColumn: (SpColumnViewColumn new
			 title: '';
			 width: 30;
			 setup: [ :aPresenter |
				 | presenter |
				 (presenter := aPresenter newPresenter)
					 layout: (SpBoxLayout newHorizontal
							  hAlignCenter;
							  add: (presenter newButton
									   addStyle: 'small';
									   yourself);
							  yourself);
					 yourself ];
			 bind: [ :aPresenter :event |
				 | button1 |
				 button1 := aPresenter layout children first.
				 button1
					 icon: (aPresenter iconNamed: #glamorousRestart);
					 action: [ self replayUpTo: event ] ];
			 yourself).
"	registry
		activateOnDoubleClick;
		whenActivatedDo: [ :selection |
			self showRegistryPopoverWith: selection selectedItem ]."
	registry transmitDo: [ :selection| self updateCodeWith: selection ].
	registry items: self events.
	code := self newCode.
	self initializeToolbar
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> initializeToolbar [

	toolbar := self newToolbar
		addStyle: 'stToolbar';
		beIcons;
		fillWith: self toolbarActions
]

{ #category : 'actions' }
StSindarinDebuggerActionRecorderPresenter >> saveScript [

	(String streamContents: [ :str |
		 events do: [ :e |
			 e sindarinActionOn: str.
			 str cr ] ]) inspect
]

{ #category : 'actions' }
StSindarinDebuggerActionRecorderPresenter >> showRegistryPopoverWith: aSteppingAction [

	self newPopover
		addStyle: 'error';
		relativeTo: registry;
		position: SpPopoverPosition right;
		presenter: (SpPresenter new
				 layout: (SpBoxLayout newTopToBottom
						  borderWidth: 2;
						  spacing: 0;
						  add: (self newLabel label: aSteppingAction printString);
						  yourself);
				 yourself);
		popup
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> subscribeToActionModel [

	self debugger debuggerActionModel
		when: StDebuggerActionModelStepAnnouncement
		send: #updateAction:
		to: self;
		when: StDebuggerActionModelRestartAnnouncement
		send: #updateAction:
		to: self;
		when: StDebuggerActionModelContextChangedAnnouncement
		send: #updateAction:
		to: self
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> toolbarActions [

	| group |
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	group register: (SindarinSaveActionsCommand forSpecContext: self).
	^ group
]

{ #category : 'updating' }
StSindarinDebuggerActionRecorderPresenter >> updateAction: aStepAnnouncement [

	self events add: aStepAnnouncement.
	registry items: self events reversed
]

{ #category : 'updating' }
StSindarinDebuggerActionRecorderPresenter >> updateCodeWith: selection [

	selection ifNil: [
		code text: ''.
		^ self ].
	code text: selection node methodNode sourceCode.
	code beForMethod: selection node methodNode compiledMethod.
	code selectionInterval:
		(selection node start to: selection node stop)
]
