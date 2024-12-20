Class {
	#name : 'StSindarinDebuggerActionRecorderPresenter',
	#superclass : 'SpPresenter',
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'toolbar',
		'registry',
		'table',
		'events'
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
	^ SpBoxLayout newTopToBottom
		add: #toolbar expand: false;
		add: #registry;
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
	registry := self newTable.
	registry addColumn: ((SpStringTableColumn title: 'id' evaluated: [:event | (events indexOf: event ) printString]) width: 30; yourself).
	registry addColumn: (SpStringTableColumn title: 'Action' evaluated: #yourself).
	registry addColumn: (SpStringTableColumn title: 'instruction' evaluated: [:event | event node printString]).
	registry items: self events.
	self initializeToolbar
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> initializeToolbar [

	toolbar := self newToolbar
		addStyle: 'stToolbar';
		beIcons;
		fillWith: self toolbarActions
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> subscribeToActionModel [

	self debugger debuggerActionModel
		when: StDebuggerActionModelStepAnnouncement
		send: #updateStep: 
		to: self";
		when: StDebuggerActionModelRestartAnnouncement
		send: #updateRestart
		to: self;
		when: StDebuggerActionModelContextChangedAnnouncement
		send: #updateContextChanged
		to: self;
		when: StDebuggerActionModelMethodAddedAnnouncement
		send: #updateAfterMethodAdded
		to: self;
		when: StDebuggerActionModelClearAnnouncement
		send: #debuggerActionModelCleared
		to: self"
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> toolbarActions [

	| group |
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	group register: (SindarinSaveActionsCommand forSpecContext: self).
	^ group
]

{ #category : 'updating' }
StSindarinDebuggerActionRecorderPresenter >> updateStep: aStepAnnouncement [

	self events add: aStepAnnouncement.
	registry items: self events reversed
]
