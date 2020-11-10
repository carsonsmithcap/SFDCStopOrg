({
    setPanelHeaderIcon : function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        utilityAPI.setPanelHeaderIcon({
            icon:"frozen",
            options:{iconVariant:"warning"}
        });
    }
})