<aura:application extends="force:slds">
    <aura:attribute name="number" type="Integer" default="5"/>
    <aura:attribute name="string" type="String"/>
    <aura:attribute name="html" type="String"/>
    <aura:attribute name="html1" type="String"/>
    <div class="slds-grid slds-gutters">
        <div class="slds-col">
            <div class="slds-p-left_large">
                
                <h2 class="slds-text-heading_large">Jokes API</h2>
                
                <lightning:input type="number"
                                 aura:id="number"
                                 label="Enter a number"
                                 class="slds-m-around_small slds-size_1-of-8"/>
                
                <lightning:button variant="brand"
                                  label="Get Jokes"
                                  class="slds-m-around_medium"
                                  onclick="{!c.handleClick }"/>
                
                <aura:unescapedHtml value="{!v.html}"/>
                
            </div>
        </div>
        <div class="slds-col">
            <div class="slds-p-left_large">
                
                <h2 class="slds-text-heading_large">News Generator</h2>
                
                <lightning:input type="string"
                                 aura:id="string"
                                 label="Enter country code"
                                 class="slds-m-around_small slds-size_1-of-8"/>
                
                <lightning:button variant="brand"
                                  label="Get News"
                                  class="slds-m-around_medium"
                                  onclick="{!c.handleClick1 }"/>
                
                <aura:unescapedHtml value="{!v.html1}"/>
            </div>
        </div>
    </div>
</aura:application>