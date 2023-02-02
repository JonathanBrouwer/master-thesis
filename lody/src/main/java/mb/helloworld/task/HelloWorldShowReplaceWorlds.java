package mb.helloworld.task;

import java.io.Serializable;
import java.util.Objects;

import javax.inject.Inject;

import org.checkerframework.checker.nullness.qual.Nullable;

import mb.lody.LodyClassLoaderResources;
import mb.lody.LodyScope;
import mb.lody.task.LodyParse;
import mb.pie.api.ExecContext;
import mb.pie.api.TaskDef;
import mb.pie.api.stamp.resource.ResourceStampers;
import mb.resource.ResourceKey;
import mb.spoofax.core.language.command.CommandFeedback;
import mb.spoofax.core.language.command.ShowFeedback;
import mb.aterm.common.TermToString;

@LodyScope
public class HelloWorldShowReplaceWorlds implements TaskDef<HelloWorldShowReplaceWorlds.Args, CommandFeedback> {
    public static class Args implements Serializable {
        private static final long serialVersionUID = 1L;

        public final ResourceKey file;

        public Args(ResourceKey file) {
            this.file = file;
        }

        @Override
        public boolean equals(@Nullable Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            final Args args = (Args) o;
            return file.equals(args.file);
        }

        @Override
        public int hashCode() {
            return Objects.hash(file);
        }

        @Override
        public String toString() {
            return "Args{" + "file=" + file + '}';
        }
    }


    private final LodyClassLoaderResources classloaderResources;
    private final LodyParse parse;

    @Inject
    public HelloWorldShowReplaceWorlds(LodyClassLoaderResources classloaderResources, LodyParse parse) {
        this.classloaderResources = classloaderResources;
        this.parse = parse;
    }


    @Override
    public CommandFeedback exec(ExecContext context, Args args) throws Exception {
        context.require(classloaderResources.tryGetAsNativeResource(getClass()), ResourceStampers.hashFile());
        final ResourceKey file = args.file;
        return CommandFeedback.of(ShowFeedback.showText("A", "B"));
    }

    @Override
    public String getId() {
        return getClass().getName();
    }
}
