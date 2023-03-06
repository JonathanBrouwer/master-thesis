package mb.lody.task;

import mb.lody.LodyClassLoaderResources;
import mb.lody.LodyScope;
import mb.pie.api.ExecContext;
import mb.pie.api.stamp.resource.ResourceStampers;
import mb.stratego.pie.AstStrategoTransformTaskDef;

import javax.inject.Inject;
import java.io.IOException;

@LodyScope
public class InterpretTransform extends AstStrategoTransformTaskDef {
  private final LodyClassLoaderResources classloaderResources;

  @Inject
  public InterpretTransform( // 1
    LodyClassLoaderResources classloaderResources,
    LodyGetStrategoRuntimeProvider getStrategoRuntimeProvider
  ) {
    super(getStrategoRuntimeProvider, "interpret-program"); // 2
    this.classloaderResources = classloaderResources;
  }

  @Override public String getId() { // 3
    return getClass().getName();
  }

  @Override protected void createDependencies(ExecContext context) throws IOException { // 4
    context.require(classloaderResources.tryGetAsNativeResource(getClass()), ResourceStampers.hashFile());
  }
}