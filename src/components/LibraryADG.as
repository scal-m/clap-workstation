package components
{
    import flash.events.MouseEvent;
    
    import mx.controls.AdvancedDataGrid;
    import mx.controls.listClasses.IListItemRenderer;

    public class LibraryADG extends AdvancedDataGrid
    {
        public function LibraryADG()
        {
            super();
        }
        
        override protected function mouseOverHandler(event:MouseEvent):void {
            var item:IListItemRenderer = super.mouseEventToItemRenderer(event);
            if(super.isHeaderItemRenderer(item))
                return;
                
            super.mouseOverHandler(event);
        }
        
    }
}