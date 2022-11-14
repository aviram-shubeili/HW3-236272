# Dry part

1. SnappingSheetController can be used to control the state of the snapping sheet and extract information from the sheet
   such as: snap to position, stop snapping, set snapping position, get current position, current snapping pos, is currently snapping? is attached?
2. The parameter that controls this behavior is snappingCurve and snappingDuration inside the SnappingPosition. for Example:
   snappingCurve: Curves.easeOutExpo,
   snappingDuration: Duration(seconds: 1),
   These parameters define the animation (and duration) of the snapping.
3.
    1. InkWell gives the user a more interactive experience - The user creates a splash with every tap.
    2. Gesture Detector on the other hand has a larger usability cases (callbacks such as dragging, pinching ..) and therefore more flexible 
